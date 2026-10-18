import { isPrivateIp } from "@/lib/api/is-private-ip";
import { assertSafeStorageKey } from "@/lib/storage/assert-safe-storage-key";
import {
  APP_DOMAIN,
  OG_AVATAR_URL,
  R2_URL,
  fetchWithTimeout,
} from "@dub/utils";
import { promises as dns } from "dns";
import { isIP } from "net";
import {
  SupabaseObjectClient,
  objectPath,
  signUpload,
  storageRequest,
} from "./backend/storage";

interface imageOptions {
  contentType?: string;
  width?: number;
  height?: number;
  headers?: Record<string, string>;
}

type BucketType = "public" | "private";

class StorageClient {
  private client = new SupabaseObjectClient();

  async upload({
    key,
    body,
    opts,
    bucket = "public",
  }: {
    key: string;
    body: Blob | Buffer | string;
    opts?: imageOptions;
    bucket?: BucketType;
  }) {
    let uploadBody;
    if (typeof body === "string") {
      if (this.isBase64(body)) {
        uploadBody = this.base64ToArrayBuffer(body, opts);
      } else if (this.isUrl(body)) {
        uploadBody = await this.urlToBlob(body, opts);
      } else {
        throw new Error("Invalid input: Not a base64 string or a valid URL");
      }
    } else {
      uploadBody = body;
    }

    const headers = {
      "Content-Length": String(
        uploadBody instanceof Blob ? uploadBody.size : uploadBody.byteLength,
      ),
      ...opts?.headers,
    };

    if (opts?.contentType) {
      headers["Content-Type"] = opts.contentType;
    }

    const requestUrl = this.objectRequestUrl(key, bucket);

    try {
      const response = await this.client.fetch(requestUrl, {
        method: "PUT",
        headers,
        body: uploadBody,
      });

      if (!response.ok) {
        throw new Error(response.statusText);
      }

      return {
        url: `${R2_URL}/${key}`,
      };
    } catch (error) {
      console.error("storage.upload failed", error);
      throw new Error("Failed to upload file. Please try again later.");
    }
  }

  async delete({
    key,
    bucket = "public",
  }: {
    key: string;
    bucket?: BucketType;
  }) {
    const requestUrl = this.objectRequestUrl(key, bucket);

    try {
      const response = await this.client.fetch(requestUrl, {
        method: "DELETE",
      });

      if (!response.ok) {
        throw new Error(response.statusText);
      }
    } catch (error) {
      console.error("storage.delete failed", error);
      throw new Error("Failed to delete file. Please try again later.");
    }
  }

  // Fetch object metadata (Content-Type, size, eTag) without downloading the body
  async head({ key, bucket = "public" }: { key: string; bucket?: BucketType }) {
    const response = await this.client.fetch(
      this.objectRequestUrl(key, bucket),
      {
        method: "HEAD",
      },
    );

    if (response.status === 404) {
      return null;
    }

    if (!response.ok) {
      throw new Error(
        `storage.head failed (${response.status}): ${response.statusText}`,
      );
    }

    const contentLengthHeader = response.headers.get("content-length");

    return {
      contentType: response.headers.get("content-type"),
      contentLength: contentLengthHeader
        ? Number.parseInt(contentLengthHeader, 10)
        : null,
      eTag: response.headers.get("etag"),
    };
  }

  // Read the first N bytes of an object (for magic-byte sniffing)
  async getBytes({
    key,
    bucket = "public",
    length = 4100,
  }: {
    key: string;
    bucket?: BucketType;
    length?: number;
  }) {
    const response = await this.client.fetch(
      this.objectRequestUrl(key, bucket),
      {
        method: "GET",
        headers: {
          Range: `bytes=0-${Math.max(length - 1, 0)}`,
        },
      },
    );

    if (response.status === 404) {
      return null;
    }

    if (!response.ok && response.status !== 206) {
      throw new Error(
        `storage.getBytes failed (${response.status}): ${response.statusText}`,
      );
    }

    return new Uint8Array(await response.arrayBuffer());
  }

  async getSignedUrl({
    key,
    method,
    expiresIn,
    bucket,
    headers,
  }: {
    key: string;
    method: "PUT" | "GET";
    bucket: BucketType;
    expiresIn: number;
    headers?: Record<string, string>;
  }) {
    assertSafeStorageKey(key);
    if (method === "PUT") {
      const token = signUpload({
        key,
        bucket,
        expires: Date.now() + expiresIn * 1000,
        contentType: headers?.["Content-Type"],
        contentLength: headers?.["Content-Length"]
          ? Number(headers["Content-Length"])
          : undefined,
      });
      return `${APP_DOMAIN}/api/storage/upload?token=${encodeURIComponent(token)}`;
    }
    const response = await storageRequest(
      `/object/sign/${objectPath(this._getBucketName(bucket), key)}`,
      {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ expiresIn }),
      },
    );
    if (!response.ok) throw new Error("Could not sign storage download");
    const data = await response.json();
    return `${process.env.SUPABASE_PUBLIC_URL}/storage/v1${data.signedURL}`;
  }

  async getSignedUploadUrl(opts: {
    key: string;
    bucket?: BucketType;
    expiresIn?: number;
    contentLength?: number;
    contentType?: string;
  }) {
    const headers: Record<string, string> = {};

    if (opts.contentLength) {
      headers["Content-Length"] = String(opts.contentLength);
    }

    if (opts.contentType) {
      headers["Content-Type"] = opts.contentType;
    }

    return await this.getSignedUrl({
      key: opts.key,
      method: "PUT",
      bucket: opts.bucket || "public",
      expiresIn: opts.expiresIn || 600,
      headers: Object.keys(headers).length > 0 ? headers : undefined,
    });
  }

  async getSignedDownloadUrl(opts: {
    key: string;
    bucket?: BucketType;
    expiresIn?: number;
  }) {
    return await this.getSignedUrl({
      key: opts.key,
      method: "GET",
      bucket: opts.bucket || "private",
      expiresIn: opts.expiresIn || 600,
    });
  }

  private base64ToArrayBuffer(base64: string, opts?: imageOptions) {
    const base64Data = base64.replace(/^data:.+;base64,/, "");
    const paddedBase64Data = base64Data.padEnd(
      base64Data.length + ((4 - (base64Data.length % 4)) % 4),
      "=",
    );

    const binaryString = atob(paddedBase64Data);
    const byteArray = new Uint8Array(binaryString.length);
    for (let i = 0; i < binaryString.length; i++) {
      byteArray[i] = binaryString.charCodeAt(i);
    }
    const blobProps = {};
    if (opts?.contentType) blobProps["type"] = opts.contentType;
    return new Blob([byteArray], blobProps);
  }

  private isBase64(str: string) {
    const base64Regex =
      /^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$/;

    const dataImageRegex =
      /^data:image\/[a-zA-Z0-9.+-]+;base64,(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$/;

    return base64Regex.test(str) || dataImageRegex.test(str);
  }

  private isUrl(str: string): boolean {
    try {
      new URL(str);
      return true;
    } catch (_) {
      return false;
    }
  }

  // Uses the same deny-list as `safeFetch` in `lib/api/safe-fetch.ts`.
  private async assertSafeUrl(url: string): Promise<void> {
    const { hostname, protocol } = new URL(url);

    if (protocol !== "http:" && protocol !== "https:") {
      throw new Error("Only http and https URLs are allowed.");
    }

    let address: string;
    if (isIP(hostname) !== 0) {
      address = hostname;
    } else {
      const result = await dns.lookup(hostname);
      address = result.address;
    }

    if (isPrivateIp(address)) {
      throw new Error("URL resolves to a private or internal IP address.");
    }
  }

  private async safeFetch(url: string): Promise<Response> {
    const maxRedirects = 5;
    let currentUrl = url;

    for (
      let redirectCount = 0;
      redirectCount <= maxRedirects;
      redirectCount++
    ) {
      await this.assertSafeUrl(currentUrl);

      const response = await fetchWithTimeout(currentUrl, {
        redirect: "manual",
      });

      if (response.ok) {
        return response;
      }

      if (response.status >= 300 && response.status < 400) {
        const location = response.headers.get("location");
        if (!location) {
          throw new Error("Redirect response missing location header");
        }
        currentUrl = new URL(location, currentUrl).href;
        continue;
      }

      throw new Error(
        `Failed to fetch URL: ${response.status} ${response.statusText}`,
      );
    }

    throw new Error("Too many redirects");
  }

  private async urlToBlob(url: string, opts?: imageOptions): Promise<Blob> {
    let response: Response;
    if (opts?.height || opts?.width) {
      try {
        const proxyUrl = new URL("https://wsrv.nl");
        proxyUrl.searchParams.set("url", url);
        if (opts.width) proxyUrl.searchParams.set("w", opts.width.toString());
        if (opts.height) proxyUrl.searchParams.set("h", opts.height.toString());
        proxyUrl.searchParams.set("fit", "cover");
        response = await fetchWithTimeout(proxyUrl.toString());
      } catch (error) {
        response = await this.safeFetch(url);
      }
    } else {
      response = await this.safeFetch(url);
    }
    if (!response.ok) {
      throw new Error(`Failed to fetch URL: ${response.statusText}`);
    }
    const blob = await response.blob();
    if (opts?.contentType) {
      return new Blob([blob], { type: opts.contentType });
    }
    return blob;
  }

  private objectRequestUrl(key: string, bucket: BucketType) {
    assertSafeStorageKey(key);

    return `https://storage.internal/${objectPath(this._getBucketName(bucket), key)}`;
  }

  private _getBucketName(bucket: BucketType) {
    if (bucket === "public") {
      const bucketName = process.env.STORAGE_PUBLIC_BUCKET;

      if (!bucketName) {
        throw new Error("STORAGE_PUBLIC_BUCKET is not set");
      }

      return bucketName;
    }

    if (bucket === "private") {
      const bucketName = process.env.STORAGE_PRIVATE_BUCKET;

      if (!bucketName) {
        throw new Error("STORAGE_PRIVATE_BUCKET is not set");
      }

      return bucketName;
    }

    throw new Error(`Invalid bucket type: ${bucket}`);
  }
}

export const storage = new StorageClient();

export const isStored = (url: string) => {
  return url.startsWith(R2_URL) || url.startsWith(OG_AVATAR_URL);
};

export const isNotHostedImage = (imageString: string) => {
  return !imageString.startsWith("https://");
};
