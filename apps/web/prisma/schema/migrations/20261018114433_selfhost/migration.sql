-- CreateEnum
CREATE TYPE "ProgramApplicationRejectionReason" AS ENUM ('needsMoreDetail', 'doesNotMeetRequirements', 'notTheRightFit', 'other');

-- CreateEnum
CREATE TYPE "ProgramApplicationStatus" AS ENUM ('pending', 'approved', 'rejected');

-- CreateEnum
CREATE TYPE "BountyType" AS ENUM ('performance', 'submission');

-- CreateEnum
CREATE TYPE "BountyPerformanceScope" AS ENUM ('new', 'lifetime');

-- CreateEnum
CREATE TYPE "BountySubmissionStatus" AS ENUM ('draft', 'submitted', 'approved', 'rejected', 'partiallyApproved');

-- CreateEnum
CREATE TYPE "BountySubmissionRejectionReason" AS ENUM ('invalidProof', 'duplicateSubmission', 'outOfTimeWindow', 'didNotMeetCriteria', 'other');

-- CreateEnum
CREATE TYPE "BountySubmissionFrequency" AS ENUM ('day', 'week', 'month');

-- CreateEnum
CREATE TYPE "BountyStartMode" AS ENUM ('absolute', 'relative');

-- CreateEnum
CREATE TYPE "CampaignType" AS ENUM ('marketing', 'transactional');

-- CreateEnum
CREATE TYPE "CampaignStatus" AS ENUM ('draft', 'active', 'paused', 'scheduled', 'sending', 'sent', 'canceled');

-- CreateEnum
CREATE TYPE "CommissionStatus" AS ENUM ('pending', 'processed', 'paid', 'refunded', 'duplicate', 'fraud', 'canceled', 'hold');

-- CreateEnum
CREATE TYPE "CommissionType" AS ENUM ('click', 'lead', 'sale', 'referral', 'custom');

-- CreateEnum
CREATE TYPE "CommissionSource" AS ENUM ('api', 'user', 'stripe', 'shopify', 'hubspot', 'appsflyer', 'singular', 'rewardful', 'partnerstack', 'firstpromoter', 'tolt', 'tapfiliate', 'lemonsqueezy', 'affiliatewp');

-- CreateEnum
CREATE TYPE "DiscountProvider" AS ENUM ('stripe', 'shopify', 'custom');

-- CreateEnum
CREATE TYPE "EmailDomainStatus" AS ENUM ('pending', 'verified', 'failed', 'temporary_failure', 'not_started', 'partially_verified', 'partially_failed');

-- CreateEnum
CREATE TYPE "FolderType" AS ENUM ('default', 'mega');

-- CreateEnum
CREATE TYPE "FolderAccessLevel" AS ENUM ('read', 'write');

-- CreateEnum
CREATE TYPE "FolderUserRole" AS ENUM ('owner', 'editor', 'viewer');

-- CreateEnum
CREATE TYPE "FraudEventStatus" AS ENUM ('pending', 'resolved', 'expired');

-- CreateEnum
CREATE TYPE "FraudRuleType" AS ENUM ('customerEmailMatch', 'customerEmailSuspiciousDomain', 'referralSourceBanned', 'paidTrafficDetected', 'partnerCrossProgramBan', 'partnerDuplicateAccount');

-- CreateEnum
CREATE TYPE "FraudAlertStatus" AS ENUM ('pending', 'confirmed', 'dismissed');

-- CreateEnum
CREATE TYPE "FraudAlertSource" AS ENUM ('program', 'admin');

-- CreateEnum
CREATE TYPE "PartnerLinkStructure" AS ENUM ('short', 'query', 'path');

-- CreateEnum
CREATE TYPE "InvoiceStatus" AS ENUM ('processing', 'completed', 'failed');

-- CreateEnum
CREATE TYPE "InvoiceType" AS ENUM ('partnerPayout', 'domainRenewal');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('card', 'ach', 'ach_fast', 'sepa', 'acss');

-- CreateEnum
CREATE TYPE "SubmittedLeadStatus" AS ENUM ('pending', 'qualified', 'meeting', 'negotiation', 'unqualified', 'closedWon', 'closedLost');

-- CreateEnum
CREATE TYPE "MessageType" AS ENUM ('direct', 'campaign');

-- CreateEnum
CREATE TYPE "Category" AS ENUM ('AI', 'Development', 'Design', 'Productivity', 'Finance', 'Marketing', 'Ecommerce', 'Security', 'Education', 'Health', 'Consumer', 'Support');

-- CreateEnum
CREATE TYPE "IndustryInterest" AS ENUM ('SaaS', 'DevTool', 'AI', 'Creative_And_Design', 'Productivity_Software', 'Marketing', 'Gaming', 'Finance', 'Sales', 'Ecommerce', 'Customer_Service_And_Support', 'Content_Management', 'Human_Resources', 'Security', 'Analytics_And_Data', 'Social_Media', 'Consumer_Tech', 'Education_And_Learning', 'Health_And_Fitness', 'Food_And_Beverage', 'Travel_And_Lifestyle', 'Entertainment_And_Media', 'Sports', 'Science_And_Engineering');

-- CreateEnum
CREATE TYPE "NotificationEmailType" AS ENUM ('Message', 'Bounty', 'Campaign');

-- CreateEnum
CREATE TYPE "PartnerRole" AS ENUM ('owner', 'member');

-- CreateEnum
CREATE TYPE "PartnerProfileType" AS ENUM ('individual', 'company');

-- CreateEnum
CREATE TYPE "PartnerNetworkStatus" AS ENUM ('draft', 'submitted', 'approved', 'rejected', 'trusted');

-- CreateEnum
CREATE TYPE "MonthlyTraffic" AS ENUM ('ZeroToOneThousand', 'OneThousandToTenThousand', 'TenThousandToFiftyThousand', 'FiftyThousandToOneHundredThousand', 'OneHundredThousandPlus');

-- CreateEnum
CREATE TYPE "PartnerPayoutMethod" AS ENUM ('connect', 'stablecoin', 'paypal', 'tremendous');

-- CreateEnum
CREATE TYPE "IdentityVerificationStatus" AS ENUM ('started', 'submitted', 'approved', 'declined', 'resubmissionRequested', 'expired', 'abandoned', 'review');

-- CreateEnum
CREATE TYPE "PreferredEarningStructure" AS ENUM ('Revenue_Share', 'Per_Lead', 'Per_Sale', 'Per_Click', 'One_Time_Payment');

-- CreateEnum
CREATE TYPE "SalesChannel" AS ENUM ('Blogs', 'Coupons', 'Direct_Reselling', 'Newsletters', 'Social_Media', 'Events', 'Company_Referrals');

-- CreateEnum
CREATE TYPE "PayoutStatus" AS ENUM ('pending', 'processing', 'processed', 'sent', 'completed', 'failed', 'canceled');

-- CreateEnum
CREATE TYPE "PayoutMode" AS ENUM ('internal', 'external');

-- CreateEnum
CREATE TYPE "PlatformType" AS ENUM ('website', 'youtube', 'twitter', 'linkedin', 'instagram', 'tiktok');

-- CreateEnum
CREATE TYPE "PostbackReceiver" AS ENUM ('custom', 'slack');

-- CreateEnum
CREATE TYPE "ProgramEnrollmentStatus" AS ENUM ('pending', 'approved', 'rejected', 'invited', 'declined', 'deactivated', 'banned', 'archived');

-- CreateEnum
CREATE TYPE "PartnerBannedReason" AS ENUM ('tos_violation', 'inappropriate_content', 'fake_traffic', 'fraud', 'spam', 'brand_abuse');

-- CreateEnum
CREATE TYPE "ProgramPayoutMode" AS ENUM ('internal', 'hybrid', 'external');

-- CreateEnum
CREATE TYPE "ReapplicationTimeframe" AS ENUM ('instant', 'standard', 'never');

-- CreateEnum
CREATE TYPE "EventType" AS ENUM ('click', 'lead', 'sale', 'referral', 'custom');

-- CreateEnum
CREATE TYPE "RewardStructure" AS ENUM ('percentage', 'flat');

-- CreateEnum
CREATE TYPE "RewardSpendLimitInterval" AS ENUM ('allTime', 'day', 'week', 'month');

-- CreateEnum
CREATE TYPE "WebhookReceiver" AS ENUM ('user', 'zapier', 'make', 'slack', 'segment');

-- CreateEnum
CREATE TYPE "LinkScope" AS ENUM ('workspace', 'folders', 'links');

-- CreateEnum
CREATE TYPE "WorkflowTrigger" AS ENUM ('partnerEnrolled', 'partnerMetricsUpdated', 'clickRecorded', 'commissionEarned', 'leadRecorded', 'saleRecorded');

-- CreateEnum
CREATE TYPE "PlanPeriod" AS ENUM ('monthly', 'yearly', 'quarterly', 'biweekly');

-- CreateEnum
CREATE TYPE "WorkspaceEnvironment" AS ENUM ('production', 'staging', 'sandbox');

-- CreateEnum
CREATE TYPE "StripeConnectMode" AS ENUM ('live', 'test', 'sandbox');

-- CreateEnum
CREATE TYPE "DubProduct" AS ENUM ('program', 'links');

-- CreateEnum
CREATE TYPE "WorkspaceRole" AS ENUM ('owner', 'member', 'viewer', 'billing');

-- CreateTable
CREATE TABLE "ActivityLog" (
    "id" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "parentResourceType" TEXT,
    "parentResourceId" TEXT,
    "resourceType" TEXT NOT NULL,
    "resourceId" TEXT NOT NULL,
    "userId" TEXT,
    "action" TEXT NOT NULL,
    "description" TEXT,
    "batchId" TEXT,
    "changeSet" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ActivityLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProgramApplication" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "partnerId" TEXT,
    "groupId" TEXT,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "country" TEXT,
    "website" TEXT,
    "youtube" TEXT,
    "twitter" TEXT,
    "linkedin" TEXT,
    "instagram" TEXT,
    "tiktok" TEXT,
    "formData" JSON,
    "status" "ProgramApplicationStatus" NOT NULL DEFAULT 'pending',
    "userId" TEXT,
    "rejectionReason" "ProgramApplicationRejectionReason",
    "rejectionNote" TEXT,
    "reviewedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProgramApplication_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProgramApplicationEvent" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "visitedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "startedAt" TIMESTAMP(3),
    "submittedAt" TIMESTAMP(3),
    "approvedAt" TIMESTAMP(3),
    "rejectedAt" TIMESTAMP(3),
    "country" TEXT,
    "referralSource" TEXT NOT NULL,
    "referredByPartnerId" TEXT,
    "metadata" JSON,
    "programApplicationId" TEXT,
    "partnerId" TEXT,

    CONSTRAINT "ProgramApplicationEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Bounty" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "workflowId" TEXT,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "type" "BountyType" NOT NULL,
    "startsAt" TIMESTAMP(3),
    "endsAt" TIMESTAMP(3),
    "startMode" "BountyStartMode" NOT NULL DEFAULT 'absolute',
    "endsAfterDays" INTEGER,
    "submissionsOpenAt" TIMESTAMP(3),
    "submissionFrequency" "BountySubmissionFrequency",
    "maxSubmissions" INTEGER NOT NULL DEFAULT 1,
    "rewardAmount" INTEGER,
    "rewardDescription" TEXT,
    "performanceScope" "BountyPerformanceScope",
    "submissionRequirements" JSONB,
    "socialMetricsLastSyncedAt" TIMESTAMP(3),
    "archivedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Bounty_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BountyGroup" (
    "id" TEXT NOT NULL,
    "bountyId" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,

    CONSTRAINT "BountyGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BountyPartnerTag" (
    "id" TEXT NOT NULL,
    "bountyId" TEXT NOT NULL,
    "partnerTagId" TEXT NOT NULL,

    CONSTRAINT "BountyPartnerTag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BountySubmission" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "partnerId" TEXT NOT NULL,
    "bountyId" TEXT NOT NULL,
    "performanceCount" BIGINT,
    "socialMetricCount" INTEGER,
    "approvedSocialMetricThreshold" INTEGER,
    "commissionId" TEXT,
    "userId" TEXT,
    "description" TEXT,
    "status" "BountySubmissionStatus" NOT NULL DEFAULT 'draft',
    "rejectionReason" "BountySubmissionRejectionReason",
    "rejectionNote" TEXT,
    "files" JSONB,
    "urls" JSONB,
    "periodNumber" INTEGER NOT NULL DEFAULT 1,
    "socialMetricsLastSyncedAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "reviewedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BountySubmission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Campaign" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "workflowId" TEXT,
    "userId" TEXT NOT NULL,
    "qstashMessageId" TEXT,
    "type" "CampaignType" NOT NULL,
    "status" "CampaignStatus" NOT NULL DEFAULT 'draft',
    "name" TEXT NOT NULL,
    "subject" TEXT NOT NULL,
    "preview" TEXT,
    "from" TEXT,
    "bodyJson" JSON NOT NULL,
    "scheduledAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Campaign_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CampaignGroup" (
    "id" TEXT NOT NULL,
    "campaignId" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,

    CONSTRAINT "CampaignGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CampaignPartnerTag" (
    "id" TEXT NOT NULL,
    "campaignId" TEXT NOT NULL,
    "partnerTagId" TEXT NOT NULL,

    CONSTRAINT "CampaignPartnerTag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartnerComment" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "partnerId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PartnerComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SubmittedLeadComment" (
    "id" TEXT NOT NULL,
    "leadId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "partnerId" TEXT,
    "text" TEXT NOT NULL,
    "partnerVisible" BOOLEAN NOT NULL DEFAULT false,
    "notifiedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SubmittedLeadComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Commission" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "partnerId" TEXT NOT NULL,
    "rewardId" TEXT,
    "linkId" TEXT,
    "payoutId" TEXT,
    "invoiceId" TEXT,
    "customerId" TEXT,
    "eventId" TEXT,
    "description" TEXT,
    "type" "CommissionType" NOT NULL,
    "amount" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    "earnings" INTEGER NOT NULL DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT 'usd',
    "status" "CommissionStatus" NOT NULL DEFAULT 'pending',
    "userId" TEXT,
    "source" "CommissionSource",
    "sourceCommissionId" TEXT,
    "sourcePartnerId" TEXT,
    "bountySubmissionId" TEXT,
    "metadata" JSON,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Commission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Customer" (
    "id" TEXT NOT NULL,
    "name" TEXT,
    "email" TEXT,
    "normalizedEmail" TEXT,
    "avatar" TEXT,
    "externalId" TEXT,
    "stripeCustomerId" TEXT,
    "linkId" TEXT,
    "clickId" TEXT,
    "clickedAt" TIMESTAMP(3),
    "country" TEXT,
    "sales" INTEGER NOT NULL DEFAULT 0,
    "saleAmount" BIGINT NOT NULL DEFAULT 0,
    "firstSaleAt" TIMESTAMP(3),
    "subscriptionCanceledAt" TIMESTAMP(3),
    "projectId" TEXT NOT NULL,
    "projectConnectId" TEXT,
    "programId" TEXT,
    "partnerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Customer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Dashboard" (
    "id" TEXT NOT NULL,
    "linkId" TEXT,
    "folderId" TEXT,
    "projectId" TEXT,
    "userId" TEXT,
    "doIndex" BOOLEAN NOT NULL DEFAULT false,
    "password" TEXT,
    "showConversions" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Dashboard_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Discount" (
    "id" TEXT NOT NULL,
    "programId" TEXT,
    "groupId" TEXT,
    "amount" INTEGER NOT NULL DEFAULT 0,
    "type" "RewardStructure" NOT NULL DEFAULT 'percentage',
    "maxDuration" INTEGER,
    "description" TEXT,
    "couponId" TEXT,
    "couponTestId" TEXT,
    "autoProvisionEnabledAt" TIMESTAMP(3),
    "provider" "DiscountProvider" NOT NULL DEFAULT 'stripe',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Discount_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DiscountCode" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "discountId" TEXT,
    "partnerId" TEXT NOT NULL,
    "linkId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "disabledAt" TIMESTAMP(3),

    CONSTRAINT "DiscountCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Domain" (
    "id" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "placeholder" TEXT,
    "expiredUrl" TEXT,
    "notFoundUrl" TEXT,
    "primary" BOOLEAN NOT NULL DEFAULT false,
    "archived" BOOLEAN NOT NULL DEFAULT false,
    "lastChecked" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "logo" TEXT,
    "appleAppSiteAssociation" JSONB,
    "assetLinks" JSONB,
    "deepviewData" JSONB DEFAULT '{}',
    "linkRetentionDays" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "projectId" TEXT,

    CONSTRAINT "Domain_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RegisteredDomain" (
    "id" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "domainId" TEXT,
    "autoRenewalDisabledAt" TIMESTAMP(3),
    "renewalFee" INTEGER NOT NULL DEFAULT 1200,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RegisteredDomain_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DefaultDomains" (
    "id" TEXT NOT NULL,
    "dubsh" BOOLEAN NOT NULL DEFAULT true,
    "chatgpt" BOOLEAN NOT NULL DEFAULT true,
    "sptifi" BOOLEAN NOT NULL DEFAULT true,
    "gitnew" BOOLEAN NOT NULL DEFAULT true,
    "callink" BOOLEAN NOT NULL DEFAULT true,
    "amznid" BOOLEAN NOT NULL DEFAULT true,
    "ggllink" BOOLEAN NOT NULL DEFAULT true,
    "figpage" BOOLEAN NOT NULL DEFAULT true,
    "loooooooong" BOOLEAN NOT NULL DEFAULT false,
    "projectId" TEXT NOT NULL,

    CONSTRAINT "DefaultDomains_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmailDomain" (
    "id" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "status" "EmailDomainStatus" NOT NULL DEFAULT 'pending',
    "resendDomainId" TEXT,
    "lastChecked" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EmailDomain_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Folder" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "projectId" TEXT NOT NULL,
    "type" "FolderType" NOT NULL DEFAULT 'default',
    "accessLevel" "FolderAccessLevel",
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Folder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FolderUser" (
    "id" TEXT NOT NULL,
    "folderId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "role" "FolderUserRole",
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FolderUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FolderAccessRequest" (
    "id" TEXT NOT NULL,
    "folderId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "FolderAccessRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FraudRule" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "type" "FraudRuleType" NOT NULL,
    "config" JSON,
    "disabledAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FraudRule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FraudEventGroup" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "partnerId" TEXT NOT NULL,
    "type" "FraudRuleType" NOT NULL,
    "lastEventAt" TIMESTAMP(3),
    "eventCount" INTEGER NOT NULL DEFAULT 0,
    "userId" TEXT,
    "resolutionReason" TEXT,
    "resolvedAt" TIMESTAMP(3),
    "status" "FraudEventStatus" NOT NULL DEFAULT 'pending',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FraudEventGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FraudEvent" (
    "id" TEXT NOT NULL,
    "fraudEventGroupId" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "partnerId" TEXT NOT NULL,
    "linkId" TEXT,
    "customerId" TEXT,
    "eventId" TEXT,
    "sourceProgramId" TEXT,
    "hash" TEXT NOT NULL,
    "metadata" JSON,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FraudEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FraudAlert" (
    "id" TEXT NOT NULL,
    "partnerId" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "status" "FraudAlertStatus" NOT NULL DEFAULT 'pending',
    "source" "FraudAlertSource" NOT NULL DEFAULT 'program',
    "reviewedById" TEXT,
    "reviewedAt" TIMESTAMP(3),
    "reviewNote" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FraudAlert_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartnerGroup" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "color" TEXT,
    "clickRewardId" TEXT,
    "leadRewardId" TEXT,
    "saleRewardId" TEXT,
    "referralRewardId" TEXT,
    "customRewardId" TEXT,
    "discountId" TEXT,
    "linkStructure" "PartnerLinkStructure" NOT NULL DEFAULT 'short',
    "additionalLinks" JSON,
    "maxPartnerLinks" INTEGER NOT NULL DEFAULT 0,
    "applicationFormData" JSON,
    "applicationFormPublishedAt" TIMESTAMP(3),
    "landerData" JSON,
    "landerPublishedAt" TIMESTAMP(3),
    "logo" TEXT,
    "wordmark" TEXT,
    "brandColor" TEXT,
    "holdingPeriodDays" INTEGER NOT NULL DEFAULT 0,
    "autoApprovePartnersEnabledAt" TIMESTAMP(3),
    "revenueDataSharingDisabledAt" TIMESTAMP(3),
    "submittedLeadFormData" JSON,
    "submittedLeadsEnabledAt" TIMESTAMP(3),
    "workflowId" TEXT,
    "utmTemplateId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PartnerGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartnerGroupDefaultLink" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "groupId" TEXT,
    "domain" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PartnerGroupDefaultLink_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Integration" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "projectId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "readme" TEXT,
    "developer" TEXT NOT NULL,
    "website" TEXT NOT NULL,
    "logo" TEXT,
    "screenshots" JSONB,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "installUrl" TEXT,
    "guideUrl" TEXT,
    "category" TEXT,
    "comingSoon" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Integration_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InstalledIntegration" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "integrationId" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "credentials" JSONB,
    "settings" JSONB,

    CONSTRAINT "InstalledIntegration_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Invoice" (
    "id" TEXT NOT NULL,
    "programId" TEXT,
    "workspaceId" TEXT NOT NULL,
    "number" TEXT,
    "status" "InvoiceStatus" NOT NULL DEFAULT 'processing',
    "type" "InvoiceType" NOT NULL DEFAULT 'partnerPayout',
    "payoutMode" "ProgramPayoutMode" NOT NULL DEFAULT 'internal',
    "paymentMethod" "PaymentMethod",
    "amount" INTEGER NOT NULL DEFAULT 0,
    "fee" INTEGER NOT NULL DEFAULT 0,
    "refundedAmount" INTEGER NOT NULL DEFAULT 0,
    "total" INTEGER NOT NULL DEFAULT 0,
    "externalAmount" INTEGER NOT NULL DEFAULT 0,
    "receiptUrl" TEXT,
    "refundReason" TEXT,
    "failedReason" TEXT,
    "registeredDomains" JSON,
    "stripeChargeMetadata" JSON,
    "failedAttempts" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "paidAt" TIMESTAMP(3),

    CONSTRAINT "Invoice_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "jackson_index" (
    "id" SERIAL NOT NULL,
    "key" VARCHAR(250) NOT NULL,
    "storeKey" VARCHAR(250) NOT NULL,

    CONSTRAINT "jackson_index_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "jackson_store" (
    "key" VARCHAR(250) NOT NULL,
    "value" TEXT NOT NULL,
    "iv" VARCHAR(64),
    "tag" VARCHAR(64),
    "namespace" VARCHAR(64),
    "createdAt" TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "modifiedAt" TIMESTAMP(0),

    CONSTRAINT "jackson_store_pkey" PRIMARY KEY ("key")
);

-- CreateTable
CREATE TABLE "jackson_ttl" (
    "key" VARCHAR(250) NOT NULL,
    "expiresAt" BIGINT NOT NULL,

    CONSTRAINT "jackson_ttl_pkey" PRIMARY KEY ("key")
);

-- CreateTable
CREATE TABLE "Job" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "options" JSONB,
    "scheduledAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "lastError" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Job_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SubmittedLead" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "partnerId" TEXT NOT NULL,
    "customerId" TEXT,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "company" TEXT NOT NULL,
    "formData" JSON,
    "status" "SubmittedLeadStatus" NOT NULL DEFAULT 'pending',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SubmittedLead_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Link" (
    "id" TEXT NOT NULL,
    "domain" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "shortLink" VARCHAR(400) NOT NULL,
    "archived" BOOLEAN NOT NULL DEFAULT false,
    "expiresAt" TIMESTAMP(3),
    "expiredUrl" TEXT,
    "disabledAt" TIMESTAMP(3),
    "password" TEXT,
    "trackConversion" BOOLEAN NOT NULL DEFAULT false,
    "proxy" BOOLEAN NOT NULL DEFAULT false,
    "title" TEXT,
    "description" VARCHAR(280),
    "image" TEXT,
    "video" TEXT,
    "utm_source" VARCHAR(255),
    "utm_medium" VARCHAR(255),
    "utm_campaign" VARCHAR(255),
    "utm_term" VARCHAR(255),
    "utm_content" VARCHAR(255),
    "rewrite" BOOLEAN NOT NULL DEFAULT false,
    "linkRetentionCleanupDisabledAt" TIMESTAMP(3),
    "doIndex" BOOLEAN NOT NULL DEFAULT false,
    "ios" TEXT,
    "android" TEXT,
    "geo" JSON,
    "testVariants" JSON,
    "testStartedAt" TIMESTAMP(3),
    "testCompletedAt" TIMESTAMP(3),
    "userId" TEXT,
    "projectId" TEXT,
    "folderId" TEXT,
    "externalId" TEXT,
    "tenantId" TEXT,
    "publicStats" BOOLEAN NOT NULL DEFAULT false,
    "clicks" INTEGER NOT NULL DEFAULT 0,
    "leads" INTEGER NOT NULL DEFAULT 0,
    "conversions" INTEGER NOT NULL DEFAULT 0,
    "sales" INTEGER NOT NULL DEFAULT 0,
    "saleAmount" BIGINT NOT NULL DEFAULT 0,
    "lastClicked" TIMESTAMP(3),
    "lastLeadAt" TIMESTAMP(3),
    "lastConversionAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "comments" TEXT,
    "programId" TEXT,
    "partnerId" TEXT,
    "partnerGroupDefaultLinkId" TEXT,

    CONSTRAINT "Link_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartnerLinkDetails" (
    "id" TEXT NOT NULL,
    "linkId" TEXT NOT NULL,
    "title" TEXT,
    "comments" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PartnerLinkDetails_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Message" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "partnerId" TEXT NOT NULL,
    "senderUserId" TEXT NOT NULL,
    "senderPartnerId" TEXT,
    "type" "MessageType" NOT NULL DEFAULT 'direct',
    "subject" TEXT,
    "text" TEXT NOT NULL,
    "readInApp" TIMESTAMP(3),
    "readInEmail" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Message_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MessageAttachment" (
    "id" TEXT NOT NULL,
    "messageId" TEXT NOT NULL,
    "storageKey" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "size" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MessageAttachment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "YearInReview" (
    "id" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "totalLinks" INTEGER NOT NULL,
    "totalClicks" INTEGER NOT NULL,
    "topLinks" JSONB NOT NULL,
    "topCountries" JSONB NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sentAt" TIMESTAMP(3),

    CONSTRAINT "YearInReview_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartnerRewind" (
    "id" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "totalClicks" INTEGER NOT NULL,
    "totalLeads" INTEGER NOT NULL,
    "totalRevenue" INTEGER NOT NULL,
    "totalEarnings" INTEGER NOT NULL,
    "partnerId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sentAt" TIMESTAMP(3),

    CONSTRAINT "PartnerRewind_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProgramCategory" (
    "programId" TEXT NOT NULL,
    "category" "Category" NOT NULL
);

-- CreateTable
CREATE TABLE "ProgramSimilarity" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "similarProgramId" TEXT NOT NULL,
    "similarityScore" DOUBLE PRECISION NOT NULL,
    "categorySimilarityScore" DOUBLE PRECISION NOT NULL,
    "partnerSimilarityScore" DOUBLE PRECISION NOT NULL,
    "performanceSimilarityScore" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "ProgramSimilarity_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DiscoveredPartner" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "partnerId" TEXT NOT NULL,
    "starredAt" TIMESTAMP(3),
    "ignoredAt" TIMESTAMP(3),
    "invitedAt" TIMESTAMP(3),
    "messagedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DiscoveredPartner_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NotificationEmail" (
    "id" TEXT NOT NULL,
    "emailId" TEXT NOT NULL,
    "type" "NotificationEmailType" NOT NULL,
    "messageId" TEXT,
    "bountyId" TEXT,
    "campaignId" TEXT,
    "programId" TEXT,
    "partnerId" TEXT,
    "recipientUserId" TEXT,
    "deliveredAt" TIMESTAMP(3),
    "openedAt" TIMESTAMP(3),
    "bouncedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "NotificationEmail_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserNotificationPreferences" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "dubLinks" BOOLEAN NOT NULL DEFAULT true,
    "dubPartners" BOOLEAN NOT NULL DEFAULT true,
    "partnerAccount" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "UserNotificationPreferences_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NotificationPreference" (
    "id" TEXT NOT NULL,
    "projectUserId" TEXT NOT NULL,
    "linkUsageSummary" BOOLEAN NOT NULL DEFAULT true,
    "domainConfigurationUpdates" BOOLEAN NOT NULL DEFAULT true,
    "newPartnerSale" BOOLEAN NOT NULL DEFAULT true,
    "newPartnerApplication" BOOLEAN NOT NULL DEFAULT false,
    "pendingApplicationsSummary" BOOLEAN NOT NULL DEFAULT true,
    "newBountySubmitted" BOOLEAN NOT NULL DEFAULT true,
    "newMessageFromPartner" BOOLEAN NOT NULL DEFAULT true,
    "fraudEventsSummary" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "NotificationPreference_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartnerNotificationPreferences" (
    "id" TEXT NOT NULL,
    "partnerUserId" TEXT NOT NULL,
    "commissionCreated" BOOLEAN NOT NULL DEFAULT true,
    "applicationApproved" BOOLEAN NOT NULL DEFAULT true,
    "newMessageFromProgram" BOOLEAN NOT NULL DEFAULT true,
    "marketingCampaign" BOOLEAN NOT NULL DEFAULT true,
    "connectPayoutReminder" BOOLEAN NOT NULL DEFAULT true,
    "monthlyProgramSummary" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "PartnerNotificationPreferences_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OAuthApp" (
    "id" TEXT NOT NULL,
    "integrationId" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "hashedClientSecret" TEXT NOT NULL,
    "partialClientSecret" TEXT NOT NULL,
    "redirectUris" JSONB NOT NULL,
    "pkce" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "OAuthApp_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OAuthCode" (
    "id" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "scopes" TEXT,
    "redirectUri" TEXT NOT NULL,
    "codeChallenge" TEXT,
    "codeChallengeMethod" TEXT,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OAuthCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OAuthRefreshToken" (
    "id" TEXT NOT NULL,
    "installationId" TEXT NOT NULL,
    "accessTokenId" TEXT NOT NULL,
    "hashedRefreshToken" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OAuthRefreshToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Partner" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "username" TEXT,
    "email" TEXT,
    "image" TEXT,
    "description" TEXT,
    "country" TEXT,
    "companyName" TEXT,
    "profileType" "PartnerProfileType" NOT NULL DEFAULT 'individual',
    "networkStatus" "PartnerNetworkStatus" NOT NULL DEFAULT 'draft',
    "identityVerificationStatus" "IdentityVerificationStatus",
    "identityVerifiedAt" TIMESTAMP(3),
    "veriffSessionId" TEXT,
    "veriffMetadata" JSONB,
    "defaultPayoutMethod" "PartnerPayoutMethod",
    "payoutsEnabledAt" TIMESTAMP(3),
    "connectPayoutsLastRemindedAt" TIMESTAMP(3),
    "paypalEmail" TEXT,
    "stripeConnectId" TEXT,
    "stripeRecipientId" TEXT,
    "payoutMethodHash" TEXT,
    "cryptoWalletAddress" TEXT,
    "tremendousEmail" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "submittedAt" TIMESTAMP(3),
    "reviewedAt" TIMESTAMP(3),
    "trustedAt" TIMESTAMP(3),
    "invoiceSettings" JSONB,
    "changeHistoryLog" JSONB,
    "referredByPartnerId" TEXT,
    "usersLimit" INTEGER NOT NULL DEFAULT 10,
    "monthlyTraffic" "MonthlyTraffic",

    CONSTRAINT "Partner_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartnerInvite" (
    "email" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,
    "partnerId" TEXT NOT NULL,
    "role" "PartnerRole" NOT NULL DEFAULT 'member',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "PartnerUser" (
    "id" TEXT NOT NULL,
    "role" "PartnerRole" NOT NULL DEFAULT 'member',
    "userId" TEXT NOT NULL,
    "partnerId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PartnerUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartnerIndustryInterest" (
    "partnerId" TEXT NOT NULL,
    "industryInterest" "IndustryInterest" NOT NULL
);

-- CreateTable
CREATE TABLE "PartnerPreferredEarningStructure" (
    "partnerId" TEXT NOT NULL,
    "preferredEarningStructure" "PreferredEarningStructure" NOT NULL
);

-- CreateTable
CREATE TABLE "PartnerSalesChannel" (
    "partnerId" TEXT NOT NULL,
    "salesChannel" "SalesChannel" NOT NULL
);

-- CreateTable
CREATE TABLE "Payout" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "partnerId" TEXT NOT NULL,
    "invoiceId" TEXT,
    "amount" INTEGER NOT NULL DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "status" "PayoutStatus" NOT NULL DEFAULT 'pending',
    "mode" "PayoutMode",
    "method" "PartnerPayoutMethod",
    "description" TEXT,
    "periodStart" TIMESTAMP(3),
    "periodEnd" TIMESTAMP(3),
    "paypalTransferId" TEXT,
    "stripeTransferId" TEXT,
    "stripePayoutId" TEXT,
    "stripePayoutTraceId" TEXT,
    "tremendousOrderId" TEXT,
    "failureReason" TEXT,
    "webhookEventId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT,
    "initiatedAt" TIMESTAMP(3),
    "paidAt" TIMESTAMP(3),

    CONSTRAINT "Payout_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartnerPlatform" (
    "id" TEXT NOT NULL,
    "partnerId" TEXT NOT NULL,
    "type" "PlatformType" NOT NULL,
    "identifier" TEXT NOT NULL,
    "platformId" TEXT,
    "avatarUrl" TEXT,
    "subscribers" BIGINT NOT NULL DEFAULT 0,
    "posts" BIGINT NOT NULL DEFAULT 0,
    "views" BIGINT NOT NULL DEFAULT 0,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "verifiedAt" TIMESTAMP(3),
    "lastCheckedAt" TIMESTAMP(3),

    CONSTRAINT "PartnerPlatform_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Postback" (
    "id" TEXT NOT NULL,
    "partnerId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "secret" TEXT NOT NULL,
    "triggers" JSONB NOT NULL,
    "receiver" "PostbackReceiver" NOT NULL,
    "disabledAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Postback_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Program" (
    "id" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "defaultFolderId" TEXT NOT NULL,
    "defaultGroupId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "domain" TEXT,
    "url" TEXT,
    "logo" TEXT,
    "description" TEXT,
    "primaryRewardEvent" "EventType" NOT NULL DEFAULT 'sale',
    "minPayoutAmount" INTEGER NOT NULL DEFAULT 0,
    "payoutMode" "ProgramPayoutMode" NOT NULL DEFAULT 'internal',
    "environment" "WorkspaceEnvironment" NOT NULL DEFAULT 'production',
    "inviteEmailData" JSON,
    "embedData" JSON,
    "resources" JSON,
    "applicationRequirements" JSON,
    "applicationScreeningCriteria" TEXT,
    "termsUrl" TEXT,
    "helpUrl" TEXT,
    "supportEmail" TEXT,
    "tremendousCampaignId" TEXT,
    "messagingEnabledAt" TIMESTAMP(3),
    "partnerNetworkEnabledAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "startedAt" TIMESTAMP(3),
    "deactivatedAt" TIMESTAMP(3),
    "addedToMarketplaceAt" TIMESTAMP(3),
    "featuredOnMarketplaceAt" TIMESTAMP(3),
    "marketplaceHeaderImage" TEXT,
    "marketplaceRanking" INTEGER NOT NULL DEFAULT 2147483647,

    CONSTRAINT "Program_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProgramEnrollment" (
    "id" TEXT NOT NULL,
    "partnerId" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "tenantId" TEXT,
    "groupId" TEXT,
    "applicationId" TEXT,
    "clickRewardId" TEXT,
    "leadRewardId" TEXT,
    "saleRewardId" TEXT,
    "referralRewardId" TEXT,
    "customRewardId" TEXT,
    "discountId" TEXT,
    "status" "ProgramEnrollmentStatus" NOT NULL DEFAULT 'pending',
    "totalClicks" INTEGER NOT NULL DEFAULT 0,
    "totalLeads" INTEGER NOT NULL DEFAULT 0,
    "totalConversions" INTEGER NOT NULL DEFAULT 0,
    "totalSales" INTEGER NOT NULL DEFAULT 0,
    "totalSaleAmount" BIGINT NOT NULL DEFAULT 0,
    "totalCommissions" BIGINT NOT NULL DEFAULT 0,
    "netRevenue" BIGINT NOT NULL DEFAULT 0,
    "earningsPerClick" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "averageLifetimeValue" DOUBLE PRECISION,
    "clickToLeadRate" DOUBLE PRECISION,
    "clickToConversionRate" DOUBLE PRECISION,
    "leadToConversionRate" DOUBLE PRECISION,
    "returnOnAdSpend" DOUBLE PRECISION,
    "lastConversionAt" TIMESTAMP(3),
    "daysSinceLastConversion" INTEGER,
    "consistencyScore" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "customerDataSharingEnabledAt" TIMESTAMP(3),
    "groupMoveDisabledAt" TIMESTAMP(3),
    "bannedAt" TIMESTAMP(3),
    "bannedReason" "PartnerBannedReason",
    "reapplicationTimeframe" "ReapplicationTimeframe" NOT NULL DEFAULT 'standard',
    "riskMonitoringDisabledAt" TIMESTAMP(3),
    "partnerPreferences" JSONB,

    CONSTRAINT "ProgramEnrollment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Reward" (
    "id" TEXT NOT NULL,
    "programId" TEXT,
    "groupId" TEXT,
    "description" TEXT,
    "tooltipDescription" TEXT,
    "event" "EventType" NOT NULL,
    "type" "RewardStructure" NOT NULL DEFAULT 'percentage',
    "amountInCents" INTEGER,
    "amountInPercentage" DECIMAL(5,2),
    "maxDuration" INTEGER,
    "modifiers" JSON,
    "config" JSON,
    "spendLimitAmount" INTEGER,
    "spendLimitInterval" "RewardSpendLimitInterval",
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Reward_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LinkReward" (
    "id" TEXT NOT NULL,
    "linkId" TEXT NOT NULL,
    "clickRewardId" TEXT,
    "leadRewardId" TEXT,
    "saleRewardId" TEXT,
    "discountId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "LinkReward_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "name" TEXT,
    "email" TEXT,
    "emailVerified" TIMESTAMP(3),
    "image" TEXT,
    "isMachine" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "passwordHash" TEXT,
    "invalidLoginAttempts" INTEGER NOT NULL DEFAULT 0,
    "lockedAt" TIMESTAMP(3),
    "defaultWorkspace" TEXT,
    "defaultPartnerId" TEXT,
    "source" TEXT,
    "sentMail" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Account" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    "refresh_token" TEXT,
    "refresh_token_expires_in" INTEGER,
    "access_token" TEXT,
    "expires_at" INTEGER,
    "token_type" TEXT,
    "scope" TEXT,
    "id_token" TEXT,
    "session_state" TEXT,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Session" (
    "id" TEXT NOT NULL,
    "sessionToken" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tag" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "color" TEXT NOT NULL DEFAULT 'blue',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "projectId" TEXT,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LinkTag" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "linkId" TEXT NOT NULL,
    "tagId" TEXT NOT NULL,

    CONSTRAINT "LinkTag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartnerTag" (
    "id" TEXT NOT NULL,
    "programId" TEXT,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PartnerTag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProgramPartnerTag" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "partnerId" TEXT NOT NULL,
    "partnerTagId" TEXT NOT NULL,

    CONSTRAINT "ProgramPartnerTag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Token" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "hashedKey" TEXT NOT NULL,
    "partialKey" TEXT NOT NULL,
    "expires" TIMESTAMP(3),
    "lastUsed" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "Token_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RestrictedToken" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "hashedKey" TEXT NOT NULL,
    "partialKey" TEXT NOT NULL,
    "scopes" TEXT,
    "expires" TIMESTAMP(3),
    "lastUsed" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "installationId" TEXT,

    CONSTRAINT "RestrictedToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VerificationToken" (
    "identifier" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,
    "isAdminImpersonation" BOOLEAN NOT NULL DEFAULT false
);

-- CreateTable
CREATE TABLE "EmailVerificationToken" (
    "identifier" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL
);

-- CreateTable
CREATE TABLE "PasswordResetToken" (
    "identifier" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL
);

-- CreateTable
CREATE TABLE "UtmTemplate" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "utm_source" VARCHAR(255),
    "utm_medium" VARCHAR(255),
    "utm_campaign" VARCHAR(255),
    "utm_term" VARCHAR(255),
    "utm_content" VARCHAR(255),
    "ref" VARCHAR(255),
    "userId" TEXT,
    "projectId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UtmTemplate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Webhook" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "installationId" TEXT,
    "receiver" "WebhookReceiver" NOT NULL DEFAULT 'user',
    "name" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "secret" TEXT NOT NULL,
    "triggers" JSONB NOT NULL,
    "linkScope" "LinkScope",
    "consecutiveFailures" INTEGER NOT NULL DEFAULT 0,
    "lastFailedAt" TIMESTAMP(3),
    "disabledAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Webhook_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LinkWebhook" (
    "id" TEXT NOT NULL,
    "linkId" TEXT NOT NULL,
    "webhookId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LinkWebhook_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FolderWebhook" (
    "id" TEXT NOT NULL,
    "folderId" TEXT NOT NULL,
    "webhookId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "FolderWebhook_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Workflow" (
    "id" TEXT NOT NULL,
    "programId" TEXT NOT NULL,
    "name" TEXT,
    "trigger" "WorkflowTrigger",
    "triggerConditions" JSONB NOT NULL,
    "actions" JSONB NOT NULL,
    "disabledAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Workflow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Project" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "logo" TEXT,
    "inviteCode" TEXT,
    "defaultProduct" "DubProduct" NOT NULL DEFAULT 'links',
    "defaultProgramId" TEXT,
    "plan" TEXT NOT NULL DEFAULT 'free',
    "planTier" INTEGER NOT NULL DEFAULT 1,
    "planPeriod" "PlanPeriod",
    "stripeId" TEXT,
    "billingCycleStart" INTEGER NOT NULL,
    "billingCycleEndsAt" TIMESTAMP(3),
    "trialEndsAt" TIMESTAMP(3),
    "subscriptionCanceledAt" TIMESTAMP(3),
    "paymentFailedAt" TIMESTAMP(3),
    "invoicePrefix" TEXT,
    "environment" "WorkspaceEnvironment" NOT NULL DEFAULT 'production',
    "stagingWorkspaceId" TEXT,
    "stripeConnectId" TEXT,
    "stripeConnectMode" "StripeConnectMode",
    "shopifyStoreId" TEXT,
    "totalLinks" INTEGER NOT NULL DEFAULT 0,
    "totalClicks" INTEGER NOT NULL DEFAULT 0,
    "usage" INTEGER NOT NULL DEFAULT 0,
    "usageLimit" INTEGER NOT NULL DEFAULT 1000,
    "linksUsage" INTEGER NOT NULL DEFAULT 0,
    "linksLimit" INTEGER NOT NULL DEFAULT 25,
    "payoutsUsage" INTEGER NOT NULL DEFAULT 0,
    "payoutsLimit" INTEGER NOT NULL DEFAULT 0,
    "payoutFee" DOUBLE PRECISION NOT NULL DEFAULT 0.05,
    "payoutFeeWaiverLimit" INTEGER NOT NULL DEFAULT 0,
    "payoutFeeWaiverUsage" INTEGER NOT NULL DEFAULT 0,
    "domainsLimit" INTEGER NOT NULL DEFAULT 3,
    "tagsLimit" INTEGER NOT NULL DEFAULT 5,
    "partnerTagsLimit" INTEGER NOT NULL DEFAULT 0,
    "foldersUsage" INTEGER NOT NULL DEFAULT 0,
    "foldersLimit" INTEGER NOT NULL DEFAULT 0,
    "partnersUsage" INTEGER NOT NULL DEFAULT 0,
    "partnersLimit" INTEGER NOT NULL DEFAULT 0,
    "groupsLimit" INTEGER NOT NULL DEFAULT 0,
    "usersLimit" INTEGER NOT NULL DEFAULT 1,
    "aiUsage" INTEGER NOT NULL DEFAULT 0,
    "aiLimit" INTEGER NOT NULL DEFAULT 10,
    "networkInvitesLimit" INTEGER NOT NULL DEFAULT 0,
    "referralLinkId" TEXT,
    "referredSignups" INTEGER NOT NULL DEFAULT 0,
    "store" JSONB,
    "siteVisitTrackingSettings" JSONB,
    "allowedHostnames" JSONB,
    "publishableKey" TEXT,
    "conversionEnabled" BOOLEAN NOT NULL DEFAULT false,
    "webhookEnabled" BOOLEAN NOT NULL DEFAULT false,
    "dotLinkClaimed" BOOLEAN NOT NULL DEFAULT false,
    "fastDirectDebitPayouts" BOOLEAN NOT NULL DEFAULT false,
    "ssoEmailDomain" TEXT,
    "ssoEnforcedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "usageLastChecked" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "disabledAt" TIMESTAMP(3),

    CONSTRAINT "Project_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProjectInvite" (
    "email" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,
    "projectId" TEXT NOT NULL,
    "role" "WorkspaceRole" NOT NULL DEFAULT 'member',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "ProjectUsers" (
    "id" TEXT NOT NULL,
    "role" "WorkspaceRole" NOT NULL DEFAULT 'member',
    "userId" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "workspacePreferences" JSONB,
    "defaultFolderId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProjectUsers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SentEmail" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "projectId" TEXT,

    CONSTRAINT "SentEmail_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "ActivityLog_resourceType_resourceId_idx" ON "ActivityLog"("resourceType", "resourceId");

-- CreateIndex
CREATE INDEX "ActivityLog_userId_idx" ON "ActivityLog"("userId");

-- CreateIndex
CREATE INDEX "ProgramApplication_partnerId_idx" ON "ProgramApplication"("partnerId");

-- CreateIndex
CREATE INDEX "ProgramApplication_groupId_idx" ON "ProgramApplication"("groupId");

-- CreateIndex
CREATE INDEX "ProgramApplication_email_idx" ON "ProgramApplication"("email");

-- CreateIndex
CREATE INDEX "ProgramApplication_userId_idx" ON "ProgramApplication"("userId");

-- CreateIndex
CREATE INDEX "ProgramApplication_programId_status_createdAt_idx" ON "ProgramApplication"("programId", "status", "createdAt");

-- CreateIndex
CREATE INDEX "ProgramApplicationEvent_programId_visitedAt_idx" ON "ProgramApplicationEvent"("programId", "visitedAt");

-- CreateIndex
CREATE INDEX "ProgramApplicationEvent_programId_startedAt_idx" ON "ProgramApplicationEvent"("programId", "startedAt");

-- CreateIndex
CREATE INDEX "ProgramApplicationEvent_programId_submittedAt_idx" ON "ProgramApplicationEvent"("programId", "submittedAt");

-- CreateIndex
CREATE INDEX "ProgramApplicationEvent_programId_approvedAt_idx" ON "ProgramApplicationEvent"("programId", "approvedAt");

-- CreateIndex
CREATE INDEX "ProgramApplicationEvent_programId_country_idx" ON "ProgramApplicationEvent"("programId", "country");

-- CreateIndex
CREATE INDEX "ProgramApplicationEvent_programId_referralSource_idx" ON "ProgramApplicationEvent"("programId", "referralSource");

-- CreateIndex
CREATE INDEX "ProgramApplicationEvent_programId_referredByPartnerId_idx" ON "ProgramApplicationEvent"("programId", "referredByPartnerId");

-- CreateIndex
CREATE INDEX "ProgramApplicationEvent_referredByPartnerId_idx" ON "ProgramApplicationEvent"("referredByPartnerId");

-- CreateIndex
CREATE INDEX "ProgramApplicationEvent_programApplicationId_idx" ON "ProgramApplicationEvent"("programApplicationId");

-- CreateIndex
CREATE UNIQUE INDEX "ProgramApplicationEvent_programId_partnerId_key" ON "ProgramApplicationEvent"("programId", "partnerId");

-- CreateIndex
CREATE UNIQUE INDEX "Bounty_workflowId_key" ON "Bounty"("workflowId");

-- CreateIndex
CREATE INDEX "Bounty_programId_idx" ON "Bounty"("programId");

-- CreateIndex
CREATE INDEX "BountyGroup_groupId_idx" ON "BountyGroup"("groupId");

-- CreateIndex
CREATE UNIQUE INDEX "BountyGroup_bountyId_groupId_key" ON "BountyGroup"("bountyId", "groupId");

-- CreateIndex
CREATE INDEX "BountyPartnerTag_partnerTagId_idx" ON "BountyPartnerTag"("partnerTagId");

-- CreateIndex
CREATE UNIQUE INDEX "BountyPartnerTag_bountyId_partnerTagId_key" ON "BountyPartnerTag"("bountyId", "partnerTagId");

-- CreateIndex
CREATE UNIQUE INDEX "BountySubmission_commissionId_key" ON "BountySubmission"("commissionId");

-- CreateIndex
CREATE INDEX "BountySubmission_programId_partnerId_idx" ON "BountySubmission"("programId", "partnerId");

-- CreateIndex
CREATE INDEX "BountySubmission_partnerId_idx" ON "BountySubmission"("partnerId");

-- CreateIndex
CREATE INDEX "BountySubmission_userId_idx" ON "BountySubmission"("userId");

-- CreateIndex
CREATE INDEX "BountySubmission_status_idx" ON "BountySubmission"("status");

-- CreateIndex
CREATE UNIQUE INDEX "BountySubmission_bountyId_partnerId_periodNumber_key" ON "BountySubmission"("bountyId", "partnerId", "periodNumber");

-- CreateIndex
CREATE UNIQUE INDEX "Campaign_workflowId_key" ON "Campaign"("workflowId");

-- CreateIndex
CREATE UNIQUE INDEX "Campaign_qstashMessageId_key" ON "Campaign"("qstashMessageId");

-- CreateIndex
CREATE INDEX "Campaign_programId_idx" ON "Campaign"("programId");

-- CreateIndex
CREATE INDEX "Campaign_type_status_scheduledAt_idx" ON "Campaign"("type", "status", "scheduledAt");

-- CreateIndex
CREATE INDEX "CampaignGroup_groupId_idx" ON "CampaignGroup"("groupId");

-- CreateIndex
CREATE UNIQUE INDEX "CampaignGroup_campaignId_groupId_key" ON "CampaignGroup"("campaignId", "groupId");

-- CreateIndex
CREATE INDEX "CampaignPartnerTag_partnerTagId_idx" ON "CampaignPartnerTag"("partnerTagId");

-- CreateIndex
CREATE UNIQUE INDEX "CampaignPartnerTag_campaignId_partnerTagId_key" ON "CampaignPartnerTag"("campaignId", "partnerTagId");

-- CreateIndex
CREATE INDEX "PartnerComment_programId_partnerId_idx" ON "PartnerComment"("programId", "partnerId");

-- CreateIndex
CREATE INDEX "PartnerComment_partnerId_idx" ON "PartnerComment"("partnerId");

-- CreateIndex
CREATE INDEX "PartnerComment_createdAt_idx" ON "PartnerComment"("createdAt");

-- CreateIndex
CREATE INDEX "PartnerComment_userId_idx" ON "PartnerComment"("userId");

-- CreateIndex
CREATE INDEX "SubmittedLeadComment_leadId_createdAt_idx" ON "SubmittedLeadComment"("leadId", "createdAt");

-- CreateIndex
CREATE INDEX "SubmittedLeadComment_userId_idx" ON "SubmittedLeadComment"("userId");

-- CreateIndex
CREATE INDEX "SubmittedLeadComment_partnerId_idx" ON "SubmittedLeadComment"("partnerId");

-- CreateIndex
CREATE UNIQUE INDEX "Commission_eventId_key" ON "Commission"("eventId");

-- CreateIndex
CREATE INDEX "Commission_earnings_programId_partnerId_status_idx" ON "Commission"("earnings", "programId", "partnerId", "status");

-- CreateIndex
CREATE INDEX "Commission_programId_partnerId_idx" ON "Commission"("programId", "partnerId");

-- CreateIndex
CREATE INDEX "Commission_programId_status_createdAt_amount_earnings_idx" ON "Commission"("programId", "status", "createdAt", "amount", "earnings");

-- CreateIndex
CREATE INDEX "Commission_createdAt_status_programId_earnings_idx" ON "Commission"("createdAt", "status", "programId", "earnings");

-- CreateIndex
CREATE INDEX "Commission_partnerId_customerId_type_createdAt_idx" ON "Commission"("partnerId", "customerId", "type", "createdAt");

-- CreateIndex
CREATE INDEX "Commission_partnerId_createdAt_idx" ON "Commission"("partnerId", "createdAt");

-- CreateIndex
CREATE INDEX "Commission_payoutId_idx" ON "Commission"("payoutId");

-- CreateIndex
CREATE INDEX "Commission_customerId_idx" ON "Commission"("customerId");

-- CreateIndex
CREATE INDEX "Commission_linkId_idx" ON "Commission"("linkId");

-- CreateIndex
CREATE INDEX "Commission_type_idx" ON "Commission"("type");

-- CreateIndex
CREATE INDEX "Commission_status_idx" ON "Commission"("status");

-- CreateIndex
CREATE INDEX "Commission_rewardId_idx" ON "Commission"("rewardId");

-- CreateIndex
CREATE INDEX "Commission_userId_idx" ON "Commission"("userId");

-- CreateIndex
CREATE INDEX "Commission_bountySubmissionId_idx" ON "Commission"("bountySubmissionId");

-- CreateIndex
CREATE UNIQUE INDEX "Commission_invoiceId_programId_key" ON "Commission"("invoiceId", "programId");

-- CreateIndex
CREATE UNIQUE INDEX "Customer_stripeCustomerId_key" ON "Customer"("stripeCustomerId");

-- CreateIndex
CREATE INDEX "Customer_projectId_email_idx" ON "Customer"("projectId", "email");

-- CreateIndex
CREATE INDEX "Customer_projectId_normalizedEmail_idx" ON "Customer"("projectId", "normalizedEmail");

-- CreateIndex
CREATE INDEX "Customer_projectId_createdAt_idx" ON "Customer"("projectId", "createdAt");

-- CreateIndex
CREATE INDEX "Customer_projectId_saleAmount_idx" ON "Customer"("projectId", "saleAmount");

-- CreateIndex
CREATE INDEX "Customer_projectId_firstSaleAt_idx" ON "Customer"("projectId", "firstSaleAt");

-- CreateIndex
CREATE INDEX "Customer_projectId_subscriptionCanceledAt_idx" ON "Customer"("projectId", "subscriptionCanceledAt");

-- CreateIndex
CREATE INDEX "Customer_programId_partnerId_idx" ON "Customer"("programId", "partnerId");

-- CreateIndex
CREATE INDEX "Customer_partnerId_idx" ON "Customer"("partnerId");

-- CreateIndex
CREATE INDEX "Customer_linkId_idx" ON "Customer"("linkId");

-- CreateIndex
CREATE INDEX "Customer_country_idx" ON "Customer"("country");

-- CreateIndex
CREATE INDEX "Customer_email_name_idx" ON "Customer"("email", "name");

-- CreateIndex
CREATE UNIQUE INDEX "Customer_projectId_externalId_key" ON "Customer"("projectId", "externalId");

-- CreateIndex
CREATE UNIQUE INDEX "Dashboard_linkId_key" ON "Dashboard"("linkId");

-- CreateIndex
CREATE UNIQUE INDEX "Dashboard_folderId_key" ON "Dashboard"("folderId");

-- CreateIndex
CREATE INDEX "Dashboard_projectId_idx" ON "Dashboard"("projectId");

-- CreateIndex
CREATE INDEX "Dashboard_userId_idx" ON "Dashboard"("userId");

-- CreateIndex
CREATE INDEX "Discount_programId_idx" ON "Discount"("programId");

-- CreateIndex
CREATE INDEX "Discount_groupId_idx" ON "Discount"("groupId");

-- CreateIndex
CREATE UNIQUE INDEX "DiscountCode_linkId_key" ON "DiscountCode"("linkId");

-- CreateIndex
CREATE INDEX "DiscountCode_programId_partnerId_idx" ON "DiscountCode"("programId", "partnerId");

-- CreateIndex
CREATE INDEX "DiscountCode_discountId_idx" ON "DiscountCode"("discountId");

-- CreateIndex
CREATE INDEX "DiscountCode_partnerId_idx" ON "DiscountCode"("partnerId");

-- CreateIndex
CREATE UNIQUE INDEX "DiscountCode_programId_code_key" ON "DiscountCode"("programId", "code");

-- CreateIndex
CREATE UNIQUE INDEX "Domain_slug_key" ON "Domain"("slug");

-- CreateIndex
CREATE INDEX "Domain_projectId_idx" ON "Domain"("projectId");

-- CreateIndex
CREATE INDEX "Domain_lastChecked_idx" ON "Domain"("lastChecked" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "RegisteredDomain_domainId_key" ON "RegisteredDomain"("domainId");

-- CreateIndex
CREATE INDEX "RegisteredDomain_projectId_idx" ON "RegisteredDomain"("projectId");

-- CreateIndex
CREATE INDEX "RegisteredDomain_expiresAt_idx" ON "RegisteredDomain"("expiresAt" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "DefaultDomains_projectId_key" ON "DefaultDomains"("projectId");

-- CreateIndex
CREATE UNIQUE INDEX "EmailDomain_slug_key" ON "EmailDomain"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "EmailDomain_resendDomainId_key" ON "EmailDomain"("resendDomainId");

-- CreateIndex
CREATE INDEX "EmailDomain_lastChecked_idx" ON "EmailDomain"("lastChecked" ASC);

-- CreateIndex
CREATE INDEX "EmailDomain_programId_idx" ON "EmailDomain"("programId");

-- CreateIndex
CREATE INDEX "Folder_projectId_idx" ON "Folder"("projectId");

-- CreateIndex
CREATE UNIQUE INDEX "Folder_name_projectId_key" ON "Folder"("name", "projectId");

-- CreateIndex
CREATE INDEX "FolderUser_userId_idx" ON "FolderUser"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "FolderUser_folderId_userId_key" ON "FolderUser"("folderId", "userId");

-- CreateIndex
CREATE INDEX "FolderAccessRequest_userId_idx" ON "FolderAccessRequest"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "FolderAccessRequest_folderId_userId_key" ON "FolderAccessRequest"("folderId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "FraudRule_programId_type_key" ON "FraudRule"("programId", "type");

-- CreateIndex
CREATE INDEX "FraudEventGroup_programId_partnerId_type_status_idx" ON "FraudEventGroup"("programId", "partnerId", "type", "status");

-- CreateIndex
CREATE INDEX "FraudEventGroup_partnerId_idx" ON "FraudEventGroup"("partnerId");

-- CreateIndex
CREATE INDEX "FraudEventGroup_userId_idx" ON "FraudEventGroup"("userId");

-- CreateIndex
CREATE INDEX "FraudEventGroup_lastEventAt_idx" ON "FraudEventGroup"("lastEventAt");

-- CreateIndex
CREATE INDEX "FraudEvent_programId_partnerId_customerId_idx" ON "FraudEvent"("programId", "partnerId", "customerId");

-- CreateIndex
CREATE INDEX "FraudEvent_fraudEventGroupId_idx" ON "FraudEvent"("fraudEventGroupId");

-- CreateIndex
CREATE INDEX "FraudEvent_partnerId_idx" ON "FraudEvent"("partnerId");

-- CreateIndex
CREATE INDEX "FraudEvent_customerId_idx" ON "FraudEvent"("customerId");

-- CreateIndex
CREATE INDEX "FraudEvent_linkId_idx" ON "FraudEvent"("linkId");

-- CreateIndex
CREATE INDEX "FraudEvent_eventId_idx" ON "FraudEvent"("eventId");

-- CreateIndex
CREATE INDEX "FraudEvent_hash_idx" ON "FraudEvent"("hash");

-- CreateIndex
CREATE INDEX "FraudEvent_sourceProgramId_idx" ON "FraudEvent"("sourceProgramId");

-- CreateIndex
CREATE INDEX "FraudAlert_partnerId_idx" ON "FraudAlert"("partnerId");

-- CreateIndex
CREATE INDEX "FraudAlert_status_idx" ON "FraudAlert"("status");

-- CreateIndex
CREATE INDEX "FraudAlert_createdAt_idx" ON "FraudAlert"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerGroup_clickRewardId_key" ON "PartnerGroup"("clickRewardId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerGroup_leadRewardId_key" ON "PartnerGroup"("leadRewardId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerGroup_saleRewardId_key" ON "PartnerGroup"("saleRewardId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerGroup_referralRewardId_key" ON "PartnerGroup"("referralRewardId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerGroup_customRewardId_key" ON "PartnerGroup"("customRewardId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerGroup_discountId_key" ON "PartnerGroup"("discountId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerGroup_workflowId_key" ON "PartnerGroup"("workflowId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerGroup_utmTemplateId_key" ON "PartnerGroup"("utmTemplateId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerGroup_programId_slug_key" ON "PartnerGroup"("programId", "slug");

-- CreateIndex
CREATE INDEX "PartnerGroupDefaultLink_programId_idx" ON "PartnerGroupDefaultLink"("programId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerGroupDefaultLink_groupId_url_key" ON "PartnerGroupDefaultLink"("groupId", "url");

-- CreateIndex
CREATE UNIQUE INDEX "Integration_slug_key" ON "Integration"("slug");

-- CreateIndex
CREATE INDEX "Integration_projectId_idx" ON "Integration"("projectId");

-- CreateIndex
CREATE INDEX "Integration_userId_idx" ON "Integration"("userId");

-- CreateIndex
CREATE INDEX "InstalledIntegration_projectId_idx" ON "InstalledIntegration"("projectId");

-- CreateIndex
CREATE INDEX "InstalledIntegration_integrationId_idx" ON "InstalledIntegration"("integrationId");

-- CreateIndex
CREATE UNIQUE INDEX "InstalledIntegration_userId_integrationId_projectId_key" ON "InstalledIntegration"("userId", "integrationId", "projectId");

-- CreateIndex
CREATE UNIQUE INDEX "Invoice_number_key" ON "Invoice"("number");

-- CreateIndex
CREATE INDEX "Invoice_programId_idx" ON "Invoice"("programId");

-- CreateIndex
CREATE INDEX "Invoice_workspaceId_idx" ON "Invoice"("workspaceId");

-- CreateIndex
CREATE INDEX "_jackson_index_key_store" ON "jackson_index"("key", "storeKey");

-- CreateIndex
CREATE INDEX "_jackson_store_namespace" ON "jackson_store"("namespace");

-- CreateIndex
CREATE INDEX "_jackson_ttl_expires_at" ON "jackson_ttl"("expiresAt");

-- CreateIndex
CREATE INDEX "Job_scheduledAt_attempts_idx" ON "Job"("scheduledAt", "attempts");

-- CreateIndex
CREATE INDEX "SubmittedLead_programId_partnerId_idx" ON "SubmittedLead"("programId", "partnerId");

-- CreateIndex
CREATE INDEX "SubmittedLead_partnerId_idx" ON "SubmittedLead"("partnerId");

-- CreateIndex
CREATE INDEX "SubmittedLead_customerId_idx" ON "SubmittedLead"("customerId");

-- CreateIndex
CREATE INDEX "SubmittedLead_email_name_idx" ON "SubmittedLead"("email", "name");

-- CreateIndex
CREATE UNIQUE INDEX "Link_shortLink_key" ON "Link"("shortLink");

-- CreateIndex
CREATE INDEX "Link_projectId_tenantId_idx" ON "Link"("projectId", "tenantId");

-- CreateIndex
CREATE INDEX "Link_projectId_url_idx" ON "Link"("projectId", "url");

-- CreateIndex
CREATE INDEX "Link_projectId_folderId_archived_createdAt_idx" ON "Link"("projectId", "folderId", "archived", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "Link_programId_partnerId_idx" ON "Link"("programId", "partnerId");

-- CreateIndex
CREATE INDEX "Link_partnerId_idx" ON "Link"("partnerId");

-- CreateIndex
CREATE INDEX "Link_domain_createdAt_idx" ON "Link"("domain", "createdAt");

-- CreateIndex
CREATE INDEX "Link_folderId_idx" ON "Link"("folderId");

-- CreateIndex
CREATE INDEX "Link_userId_idx" ON "Link"("userId");

-- CreateIndex
CREATE INDEX "Link_partnerGroupDefaultLinkId_idx" ON "Link"("partnerGroupDefaultLinkId");

-- CreateIndex
CREATE UNIQUE INDEX "Link_domain_key_key" ON "Link"("domain", "key");

-- CreateIndex
CREATE UNIQUE INDEX "Link_projectId_externalId_key" ON "Link"("projectId", "externalId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerLinkDetails_linkId_key" ON "PartnerLinkDetails"("linkId");

-- CreateIndex
CREATE INDEX "Message_programId_partnerId_idx" ON "Message"("programId", "partnerId");

-- CreateIndex
CREATE INDEX "Message_partnerId_idx" ON "Message"("partnerId");

-- CreateIndex
CREATE INDEX "Message_senderPartnerId_idx" ON "Message"("senderPartnerId");

-- CreateIndex
CREATE INDEX "Message_senderUserId_idx" ON "Message"("senderUserId");

-- CreateIndex
CREATE INDEX "MessageAttachment_messageId_idx" ON "MessageAttachment"("messageId");

-- CreateIndex
CREATE INDEX "YearInReview_workspaceId_idx" ON "YearInReview"("workspaceId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerRewind_partnerId_year_key" ON "PartnerRewind"("partnerId", "year");

-- CreateIndex
CREATE UNIQUE INDEX "ProgramCategory_programId_category_key" ON "ProgramCategory"("programId", "category");

-- CreateIndex
CREATE INDEX "ProgramSimilarity_programId_similarityScore_idx" ON "ProgramSimilarity"("programId", "similarityScore");

-- CreateIndex
CREATE INDEX "ProgramSimilarity_similarProgramId_idx" ON "ProgramSimilarity"("similarProgramId");

-- CreateIndex
CREATE UNIQUE INDEX "ProgramSimilarity_programId_similarProgramId_key" ON "ProgramSimilarity"("programId", "similarProgramId");

-- CreateIndex
CREATE INDEX "DiscoveredPartner_partnerId_idx" ON "DiscoveredPartner"("partnerId");

-- CreateIndex
CREATE UNIQUE INDEX "DiscoveredPartner_programId_partnerId_key" ON "DiscoveredPartner"("programId", "partnerId");

-- CreateIndex
CREATE UNIQUE INDEX "NotificationEmail_emailId_key" ON "NotificationEmail"("emailId");

-- CreateIndex
CREATE INDEX "NotificationEmail_type_idx" ON "NotificationEmail"("type");

-- CreateIndex
CREATE INDEX "NotificationEmail_messageId_idx" ON "NotificationEmail"("messageId");

-- CreateIndex
CREATE INDEX "NotificationEmail_bountyId_idx" ON "NotificationEmail"("bountyId");

-- CreateIndex
CREATE INDEX "NotificationEmail_campaignId_idx" ON "NotificationEmail"("campaignId");

-- CreateIndex
CREATE INDEX "NotificationEmail_partnerId_idx" ON "NotificationEmail"("partnerId");

-- CreateIndex
CREATE UNIQUE INDEX "UserNotificationPreferences_userId_key" ON "UserNotificationPreferences"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "NotificationPreference_projectUserId_key" ON "NotificationPreference"("projectUserId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerNotificationPreferences_partnerUserId_key" ON "PartnerNotificationPreferences"("partnerUserId");

-- CreateIndex
CREATE UNIQUE INDEX "OAuthApp_integrationId_key" ON "OAuthApp"("integrationId");

-- CreateIndex
CREATE UNIQUE INDEX "OAuthApp_clientId_key" ON "OAuthApp"("clientId");

-- CreateIndex
CREATE UNIQUE INDEX "OAuthCode_code_key" ON "OAuthCode"("code");

-- CreateIndex
CREATE INDEX "OAuthCode_clientId_idx" ON "OAuthCode"("clientId");

-- CreateIndex
CREATE INDEX "OAuthCode_userId_idx" ON "OAuthCode"("userId");

-- CreateIndex
CREATE INDEX "OAuthCode_projectId_idx" ON "OAuthCode"("projectId");

-- CreateIndex
CREATE UNIQUE INDEX "OAuthRefreshToken_hashedRefreshToken_key" ON "OAuthRefreshToken"("hashedRefreshToken");

-- CreateIndex
CREATE INDEX "OAuthRefreshToken_installationId_idx" ON "OAuthRefreshToken"("installationId");

-- CreateIndex
CREATE INDEX "OAuthRefreshToken_accessTokenId_idx" ON "OAuthRefreshToken"("accessTokenId");

-- CreateIndex
CREATE UNIQUE INDEX "Partner_username_key" ON "Partner"("username");

-- CreateIndex
CREATE UNIQUE INDEX "Partner_email_key" ON "Partner"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Partner_veriffSessionId_key" ON "Partner"("veriffSessionId");

-- CreateIndex
CREATE UNIQUE INDEX "Partner_paypalEmail_key" ON "Partner"("paypalEmail");

-- CreateIndex
CREATE UNIQUE INDEX "Partner_stripeConnectId_key" ON "Partner"("stripeConnectId");

-- CreateIndex
CREATE UNIQUE INDEX "Partner_stripeRecipientId_key" ON "Partner"("stripeRecipientId");

-- CreateIndex
CREATE INDEX "Partner_country_idx" ON "Partner"("country");

-- CreateIndex
CREATE INDEX "Partner_networkStatus_idx" ON "Partner"("networkStatus");

-- CreateIndex
CREATE INDEX "Partner_createdAt_idx" ON "Partner"("createdAt");

-- CreateIndex
CREATE INDEX "Partner_payoutMethodHash_idx" ON "Partner"("payoutMethodHash");

-- CreateIndex
CREATE INDEX "Partner_cryptoWalletAddress_idx" ON "Partner"("cryptoWalletAddress");

-- CreateIndex
CREATE INDEX "Partner_identityVerifiedAt_idx" ON "Partner"("identityVerifiedAt");

-- CreateIndex
CREATE INDEX "Partner_referredByPartnerId_idx" ON "Partner"("referredByPartnerId");

-- CreateIndex
CREATE INDEX "Partner_tremendousEmail_idx" ON "Partner"("tremendousEmail");

-- CreateIndex
CREATE INDEX "Partner_email_name_companyName_idx" ON "Partner"("email", "name", "companyName");

-- CreateIndex
CREATE INDEX "PartnerInvite_partnerId_idx" ON "PartnerInvite"("partnerId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerInvite_email_partnerId_key" ON "PartnerInvite"("email", "partnerId");

-- CreateIndex
CREATE INDEX "PartnerUser_partnerId_idx" ON "PartnerUser"("partnerId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerUser_userId_partnerId_key" ON "PartnerUser"("userId", "partnerId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerIndustryInterest_partnerId_industryInterest_key" ON "PartnerIndustryInterest"("partnerId", "industryInterest");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerPreferredEarningStructure_partnerId_preferredEarning_key" ON "PartnerPreferredEarningStructure"("partnerId", "preferredEarningStructure");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerSalesChannel_partnerId_salesChannel_key" ON "PartnerSalesChannel"("partnerId", "salesChannel");

-- CreateIndex
CREATE UNIQUE INDEX "Payout_paypalTransferId_key" ON "Payout"("paypalTransferId");

-- CreateIndex
CREATE UNIQUE INDEX "Payout_webhookEventId_key" ON "Payout"("webhookEventId");

-- CreateIndex
CREATE INDEX "Payout_programId_status_idx" ON "Payout"("programId", "status");

-- CreateIndex
CREATE INDEX "Payout_programId_partnerId_idx" ON "Payout"("programId", "partnerId");

-- CreateIndex
CREATE INDEX "Payout_partnerId_idx" ON "Payout"("partnerId");

-- CreateIndex
CREATE INDEX "Payout_invoiceId_idx" ON "Payout"("invoiceId");

-- CreateIndex
CREATE INDEX "Payout_status_idx" ON "Payout"("status");

-- CreateIndex
CREATE INDEX "Payout_updatedAt_status_idx" ON "Payout"("updatedAt", "status");

-- CreateIndex
CREATE INDEX "Payout_method_idx" ON "Payout"("method");

-- CreateIndex
CREATE INDEX "Payout_userId_idx" ON "Payout"("userId");

-- CreateIndex
CREATE INDEX "Payout_stripePayoutId_idx" ON "Payout"("stripePayoutId");

-- CreateIndex
CREATE INDEX "Payout_stripeTransferId_idx" ON "Payout"("stripeTransferId");

-- CreateIndex
CREATE INDEX "Payout_tremendousOrderId_idx" ON "Payout"("tremendousOrderId");

-- CreateIndex
CREATE INDEX "PartnerPlatform_type_verifiedAt_lastCheckedAt_idx" ON "PartnerPlatform"("type", "verifiedAt", "lastCheckedAt");

-- CreateIndex
CREATE INDEX "PartnerPlatform_identifier_idx" ON "PartnerPlatform"("identifier");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerPlatform_partnerId_type_key" ON "PartnerPlatform"("partnerId", "type");

-- CreateIndex
CREATE INDEX "Postback_partnerId_idx" ON "Postback"("partnerId");

-- CreateIndex
CREATE UNIQUE INDEX "Program_slug_key" ON "Program"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "Program_domain_key" ON "Program"("domain");

-- CreateIndex
CREATE INDEX "Program_workspaceId_idx" ON "Program"("workspaceId");

-- CreateIndex
CREATE INDEX "Program_addedToMarketplaceAt_idx" ON "Program"("addedToMarketplaceAt");

-- CreateIndex
CREATE UNIQUE INDEX "ProgramEnrollment_applicationId_key" ON "ProgramEnrollment"("applicationId");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_programId_status_createdAt_idx" ON "ProgramEnrollment"("programId", "status", "createdAt");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_programId_status_totalClicks_idx" ON "ProgramEnrollment"("programId", "status", "totalClicks");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_programId_status_totalLeads_idx" ON "ProgramEnrollment"("programId", "status", "totalLeads");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_programId_status_totalConversions_idx" ON "ProgramEnrollment"("programId", "status", "totalConversions");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_programId_status_totalSaleAmount_idx" ON "ProgramEnrollment"("programId", "status", "totalSaleAmount");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_programId_status_totalCommissions_idx" ON "ProgramEnrollment"("programId", "status", "totalCommissions");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_programId_status_netRevenue_idx" ON "ProgramEnrollment"("programId", "status", "netRevenue");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_programId_status_earningsPerClick_idx" ON "ProgramEnrollment"("programId", "status", "earningsPerClick");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_programId_status_averageLifetimeValue_idx" ON "ProgramEnrollment"("programId", "status", "averageLifetimeValue");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_programId_status_clickToLeadRate_idx" ON "ProgramEnrollment"("programId", "status", "clickToLeadRate");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_programId_status_clickToConversionRate_idx" ON "ProgramEnrollment"("programId", "status", "clickToConversionRate");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_programId_status_leadToConversionRate_idx" ON "ProgramEnrollment"("programId", "status", "leadToConversionRate");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_programId_status_returnOnAdSpend_idx" ON "ProgramEnrollment"("programId", "status", "returnOnAdSpend");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_programId_groupId_idx" ON "ProgramEnrollment"("programId", "groupId");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_groupId_status_idx" ON "ProgramEnrollment"("groupId", "status");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_status_idx" ON "ProgramEnrollment"("status");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_clickRewardId_idx" ON "ProgramEnrollment"("clickRewardId");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_leadRewardId_idx" ON "ProgramEnrollment"("leadRewardId");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_saleRewardId_idx" ON "ProgramEnrollment"("saleRewardId");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_referralRewardId_idx" ON "ProgramEnrollment"("referralRewardId");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_customRewardId_idx" ON "ProgramEnrollment"("customRewardId");

-- CreateIndex
CREATE INDEX "ProgramEnrollment_discountId_idx" ON "ProgramEnrollment"("discountId");

-- CreateIndex
CREATE UNIQUE INDEX "ProgramEnrollment_partnerId_programId_key" ON "ProgramEnrollment"("partnerId", "programId");

-- CreateIndex
CREATE UNIQUE INDEX "ProgramEnrollment_tenantId_programId_key" ON "ProgramEnrollment"("tenantId", "programId");

-- CreateIndex
CREATE INDEX "Reward_programId_event_idx" ON "Reward"("programId", "event");

-- CreateIndex
CREATE INDEX "Reward_event_idx" ON "Reward"("event");

-- CreateIndex
CREATE INDEX "Reward_groupId_idx" ON "Reward"("groupId");

-- CreateIndex
CREATE UNIQUE INDEX "LinkReward_linkId_key" ON "LinkReward"("linkId");

-- CreateIndex
CREATE INDEX "LinkReward_clickRewardId_idx" ON "LinkReward"("clickRewardId");

-- CreateIndex
CREATE INDEX "LinkReward_leadRewardId_idx" ON "LinkReward"("leadRewardId");

-- CreateIndex
CREATE INDEX "LinkReward_saleRewardId_idx" ON "LinkReward"("saleRewardId");

-- CreateIndex
CREATE INDEX "LinkReward_discountId_idx" ON "LinkReward"("discountId");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_createdAt_idx" ON "User"("createdAt");

-- CreateIndex
CREATE INDEX "User_defaultWorkspace_idx" ON "User"("defaultWorkspace");

-- CreateIndex
CREATE INDEX "User_source_idx" ON "User"("source");

-- CreateIndex
CREATE INDEX "User_sentMail_idx" ON "User"("sentMail");

-- CreateIndex
CREATE INDEX "Account_userId_idx" ON "Account"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON "Account"("provider", "providerAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "Session_sessionToken_key" ON "Session"("sessionToken");

-- CreateIndex
CREATE INDEX "Session_userId_idx" ON "Session"("userId");

-- CreateIndex
CREATE INDEX "Tag_projectId_idx" ON "Tag"("projectId");

-- CreateIndex
CREATE UNIQUE INDEX "Tag_name_projectId_key" ON "Tag"("name", "projectId");

-- CreateIndex
CREATE INDEX "LinkTag_tagId_idx" ON "LinkTag"("tagId");

-- CreateIndex
CREATE UNIQUE INDEX "LinkTag_linkId_tagId_key" ON "LinkTag"("linkId", "tagId");

-- CreateIndex
CREATE INDEX "PartnerTag_programId_idx" ON "PartnerTag"("programId");

-- CreateIndex
CREATE UNIQUE INDEX "PartnerTag_programId_name_key" ON "PartnerTag"("programId", "name");

-- CreateIndex
CREATE INDEX "ProgramPartnerTag_partnerId_idx" ON "ProgramPartnerTag"("partnerId");

-- CreateIndex
CREATE INDEX "ProgramPartnerTag_programId_partnerId_idx" ON "ProgramPartnerTag"("programId", "partnerId");

-- CreateIndex
CREATE INDEX "ProgramPartnerTag_partnerTagId_programId_idx" ON "ProgramPartnerTag"("partnerTagId", "programId");

-- CreateIndex
CREATE UNIQUE INDEX "ProgramPartnerTag_partnerTagId_partnerId_key" ON "ProgramPartnerTag"("partnerTagId", "partnerId");

-- CreateIndex
CREATE UNIQUE INDEX "Token_hashedKey_key" ON "Token"("hashedKey");

-- CreateIndex
CREATE INDEX "Token_userId_idx" ON "Token"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "RestrictedToken_hashedKey_key" ON "RestrictedToken"("hashedKey");

-- CreateIndex
CREATE INDEX "RestrictedToken_userId_idx" ON "RestrictedToken"("userId");

-- CreateIndex
CREATE INDEX "RestrictedToken_projectId_idx" ON "RestrictedToken"("projectId");

-- CreateIndex
CREATE INDEX "RestrictedToken_installationId_idx" ON "RestrictedToken"("installationId");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_token_key" ON "VerificationToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_identifier_token_key" ON "VerificationToken"("identifier", "token");

-- CreateIndex
CREATE UNIQUE INDEX "EmailVerificationToken_token_key" ON "EmailVerificationToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "EmailVerificationToken_identifier_token_key" ON "EmailVerificationToken"("identifier", "token");

-- CreateIndex
CREATE UNIQUE INDEX "PasswordResetToken_token_key" ON "PasswordResetToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "PasswordResetToken_identifier_token_key" ON "PasswordResetToken"("identifier", "token");

-- CreateIndex
CREATE INDEX "UtmTemplate_userId_idx" ON "UtmTemplate"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "UtmTemplate_projectId_name_key" ON "UtmTemplate"("projectId", "name");

-- CreateIndex
CREATE INDEX "Webhook_projectId_idx" ON "Webhook"("projectId");

-- CreateIndex
CREATE INDEX "Webhook_installationId_idx" ON "Webhook"("installationId");

-- CreateIndex
CREATE INDEX "LinkWebhook_webhookId_idx" ON "LinkWebhook"("webhookId");

-- CreateIndex
CREATE UNIQUE INDEX "LinkWebhook_linkId_webhookId_key" ON "LinkWebhook"("linkId", "webhookId");

-- CreateIndex
CREATE INDEX "FolderWebhook_webhookId_idx" ON "FolderWebhook"("webhookId");

-- CreateIndex
CREATE UNIQUE INDEX "FolderWebhook_folderId_webhookId_key" ON "FolderWebhook"("folderId", "webhookId");

-- CreateIndex
CREATE INDEX "Workflow_programId_trigger_idx" ON "Workflow"("programId", "trigger");

-- CreateIndex
CREATE UNIQUE INDEX "Project_slug_key" ON "Project"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "Project_inviteCode_key" ON "Project"("inviteCode");

-- CreateIndex
CREATE UNIQUE INDEX "Project_defaultProgramId_key" ON "Project"("defaultProgramId");

-- CreateIndex
CREATE UNIQUE INDEX "Project_stripeId_key" ON "Project"("stripeId");

-- CreateIndex
CREATE UNIQUE INDEX "Project_invoicePrefix_key" ON "Project"("invoicePrefix");

-- CreateIndex
CREATE UNIQUE INDEX "Project_stagingWorkspaceId_key" ON "Project"("stagingWorkspaceId");

-- CreateIndex
CREATE UNIQUE INDEX "Project_shopifyStoreId_key" ON "Project"("shopifyStoreId");

-- CreateIndex
CREATE UNIQUE INDEX "Project_referralLinkId_key" ON "Project"("referralLinkId");

-- CreateIndex
CREATE UNIQUE INDEX "Project_publishableKey_key" ON "Project"("publishableKey");

-- CreateIndex
CREATE UNIQUE INDEX "Project_ssoEmailDomain_key" ON "Project"("ssoEmailDomain");

-- CreateIndex
CREATE INDEX "Project_usageLastChecked_idx" ON "Project"("usageLastChecked" ASC);

-- CreateIndex
CREATE INDEX "Project_trialEndsAt_idx" ON "Project"("trialEndsAt");

-- CreateIndex
CREATE UNIQUE INDEX "Project_stripeConnectId_stripeConnectMode_key" ON "Project"("stripeConnectId", "stripeConnectMode");

-- CreateIndex
CREATE INDEX "ProjectInvite_projectId_idx" ON "ProjectInvite"("projectId");

-- CreateIndex
CREATE UNIQUE INDEX "ProjectInvite_email_projectId_key" ON "ProjectInvite"("email", "projectId");

-- CreateIndex
CREATE INDEX "ProjectUsers_projectId_idx" ON "ProjectUsers"("projectId");

-- CreateIndex
CREATE UNIQUE INDEX "ProjectUsers_userId_projectId_key" ON "ProjectUsers"("userId", "projectId");

-- CreateIndex
CREATE INDEX "SentEmail_projectId_idx" ON "SentEmail"("projectId");

-- AddForeignKey
ALTER TABLE "ActivityLog" ADD CONSTRAINT "ActivityLog_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramApplication" ADD CONSTRAINT "ProgramApplication_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramApplication" ADD CONSTRAINT "ProgramApplication_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramApplication" ADD CONSTRAINT "ProgramApplication_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "PartnerGroup"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramApplication" ADD CONSTRAINT "ProgramApplication_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramApplicationEvent" ADD CONSTRAINT "ProgramApplicationEvent_referredByPartnerId_fkey" FOREIGN KEY ("referredByPartnerId") REFERENCES "Partner"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramApplicationEvent" ADD CONSTRAINT "ProgramApplicationEvent_programApplicationId_fkey" FOREIGN KEY ("programApplicationId") REFERENCES "ProgramApplication"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramApplicationEvent" ADD CONSTRAINT "ProgramApplicationEvent_programId_partnerId_fkey" FOREIGN KEY ("programId", "partnerId") REFERENCES "ProgramEnrollment"("programId", "partnerId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bounty" ADD CONSTRAINT "Bounty_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bounty" ADD CONSTRAINT "Bounty_workflowId_fkey" FOREIGN KEY ("workflowId") REFERENCES "Workflow"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BountyGroup" ADD CONSTRAINT "BountyGroup_bountyId_fkey" FOREIGN KEY ("bountyId") REFERENCES "Bounty"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BountyGroup" ADD CONSTRAINT "BountyGroup_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "PartnerGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BountyPartnerTag" ADD CONSTRAINT "BountyPartnerTag_bountyId_fkey" FOREIGN KEY ("bountyId") REFERENCES "Bounty"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BountyPartnerTag" ADD CONSTRAINT "BountyPartnerTag_partnerTagId_fkey" FOREIGN KEY ("partnerTagId") REFERENCES "PartnerTag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BountySubmission" ADD CONSTRAINT "BountySubmission_bountyId_fkey" FOREIGN KEY ("bountyId") REFERENCES "Bounty"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BountySubmission" ADD CONSTRAINT "BountySubmission_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BountySubmission" ADD CONSTRAINT "BountySubmission_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BountySubmission" ADD CONSTRAINT "BountySubmission_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BountySubmission" ADD CONSTRAINT "BountySubmission_programId_partnerId_fkey" FOREIGN KEY ("programId", "partnerId") REFERENCES "ProgramEnrollment"("programId", "partnerId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Campaign" ADD CONSTRAINT "Campaign_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Campaign" ADD CONSTRAINT "Campaign_workflowId_fkey" FOREIGN KEY ("workflowId") REFERENCES "Workflow"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CampaignGroup" ADD CONSTRAINT "CampaignGroup_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "Campaign"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CampaignGroup" ADD CONSTRAINT "CampaignGroup_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "PartnerGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CampaignPartnerTag" ADD CONSTRAINT "CampaignPartnerTag_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "Campaign"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CampaignPartnerTag" ADD CONSTRAINT "CampaignPartnerTag_partnerTagId_fkey" FOREIGN KEY ("partnerTagId") REFERENCES "PartnerTag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerComment" ADD CONSTRAINT "PartnerComment_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerComment" ADD CONSTRAINT "PartnerComment_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerComment" ADD CONSTRAINT "PartnerComment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubmittedLeadComment" ADD CONSTRAINT "SubmittedLeadComment_leadId_fkey" FOREIGN KEY ("leadId") REFERENCES "SubmittedLead"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubmittedLeadComment" ADD CONSTRAINT "SubmittedLeadComment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubmittedLeadComment" ADD CONSTRAINT "SubmittedLeadComment_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Commission" ADD CONSTRAINT "Commission_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Commission" ADD CONSTRAINT "Commission_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Commission" ADD CONSTRAINT "Commission_programId_partnerId_fkey" FOREIGN KEY ("programId", "partnerId") REFERENCES "ProgramEnrollment"("programId", "partnerId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Commission" ADD CONSTRAINT "Commission_payoutId_fkey" FOREIGN KEY ("payoutId") REFERENCES "Payout"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Commission" ADD CONSTRAINT "Commission_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES "Link"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Commission" ADD CONSTRAINT "Commission_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Commission" ADD CONSTRAINT "Commission_rewardId_fkey" FOREIGN KEY ("rewardId") REFERENCES "Reward"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Commission" ADD CONSTRAINT "Commission_bountySubmissionId_fkey" FOREIGN KEY ("bountySubmissionId") REFERENCES "BountySubmission"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Commission" ADD CONSTRAINT "Commission_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Customer" ADD CONSTRAINT "Customer_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Customer" ADD CONSTRAINT "Customer_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES "Link"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Customer" ADD CONSTRAINT "Customer_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Customer" ADD CONSTRAINT "Customer_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Customer" ADD CONSTRAINT "Customer_programId_partnerId_fkey" FOREIGN KEY ("programId", "partnerId") REFERENCES "ProgramEnrollment"("programId", "partnerId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Dashboard" ADD CONSTRAINT "Dashboard_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES "Link"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Dashboard" ADD CONSTRAINT "Dashboard_folderId_fkey" FOREIGN KEY ("folderId") REFERENCES "Folder"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Dashboard" ADD CONSTRAINT "Dashboard_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Dashboard" ADD CONSTRAINT "Dashboard_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Discount" ADD CONSTRAINT "Discount_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Discount" ADD CONSTRAINT "Discount_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "PartnerGroup"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "DiscountCode" ADD CONSTRAINT "DiscountCode_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DiscountCode" ADD CONSTRAINT "DiscountCode_discountId_fkey" FOREIGN KEY ("discountId") REFERENCES "Discount"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DiscountCode" ADD CONSTRAINT "DiscountCode_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DiscountCode" ADD CONSTRAINT "DiscountCode_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES "Link"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DiscountCode" ADD CONSTRAINT "DiscountCode_programId_partnerId_fkey" FOREIGN KEY ("programId", "partnerId") REFERENCES "ProgramEnrollment"("programId", "partnerId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Domain" ADD CONSTRAINT "Domain_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RegisteredDomain" ADD CONSTRAINT "RegisteredDomain_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RegisteredDomain" ADD CONSTRAINT "RegisteredDomain_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "Domain"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DefaultDomains" ADD CONSTRAINT "DefaultDomains_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmailDomain" ADD CONSTRAINT "EmailDomain_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Folder" ADD CONSTRAINT "Folder_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FolderUser" ADD CONSTRAINT "FolderUser_folderId_fkey" FOREIGN KEY ("folderId") REFERENCES "Folder"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FolderUser" ADD CONSTRAINT "FolderUser_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FolderAccessRequest" ADD CONSTRAINT "FolderAccessRequest_folderId_fkey" FOREIGN KEY ("folderId") REFERENCES "Folder"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FolderAccessRequest" ADD CONSTRAINT "FolderAccessRequest_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FraudRule" ADD CONSTRAINT "FraudRule_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FraudEventGroup" ADD CONSTRAINT "FraudEventGroup_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FraudEventGroup" ADD CONSTRAINT "FraudEventGroup_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FraudEventGroup" ADD CONSTRAINT "FraudEventGroup_programId_partnerId_fkey" FOREIGN KEY ("programId", "partnerId") REFERENCES "ProgramEnrollment"("programId", "partnerId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FraudEventGroup" ADD CONSTRAINT "FraudEventGroup_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FraudEvent" ADD CONSTRAINT "FraudEvent_fraudEventGroupId_fkey" FOREIGN KEY ("fraudEventGroupId") REFERENCES "FraudEventGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FraudEvent" ADD CONSTRAINT "FraudEvent_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FraudEvent" ADD CONSTRAINT "FraudEvent_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FraudEvent" ADD CONSTRAINT "FraudEvent_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES "Link"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FraudEvent" ADD CONSTRAINT "FraudEvent_sourceProgramId_fkey" FOREIGN KEY ("sourceProgramId") REFERENCES "Program"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FraudAlert" ADD CONSTRAINT "FraudAlert_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FraudAlert" ADD CONSTRAINT "FraudAlert_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FraudAlert" ADD CONSTRAINT "FraudAlert_reviewedById_fkey" FOREIGN KEY ("reviewedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FraudAlert" ADD CONSTRAINT "FraudAlert_programId_partnerId_fkey" FOREIGN KEY ("programId", "partnerId") REFERENCES "ProgramEnrollment"("programId", "partnerId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerGroup" ADD CONSTRAINT "PartnerGroup_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerGroup" ADD CONSTRAINT "PartnerGroup_clickRewardId_fkey" FOREIGN KEY ("clickRewardId") REFERENCES "Reward"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerGroup" ADD CONSTRAINT "PartnerGroup_leadRewardId_fkey" FOREIGN KEY ("leadRewardId") REFERENCES "Reward"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerGroup" ADD CONSTRAINT "PartnerGroup_saleRewardId_fkey" FOREIGN KEY ("saleRewardId") REFERENCES "Reward"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerGroup" ADD CONSTRAINT "PartnerGroup_referralRewardId_fkey" FOREIGN KEY ("referralRewardId") REFERENCES "Reward"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerGroup" ADD CONSTRAINT "PartnerGroup_customRewardId_fkey" FOREIGN KEY ("customRewardId") REFERENCES "Reward"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerGroup" ADD CONSTRAINT "PartnerGroup_discountId_fkey" FOREIGN KEY ("discountId") REFERENCES "Discount"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerGroup" ADD CONSTRAINT "PartnerGroup_workflowId_fkey" FOREIGN KEY ("workflowId") REFERENCES "Workflow"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerGroup" ADD CONSTRAINT "PartnerGroup_utmTemplateId_fkey" FOREIGN KEY ("utmTemplateId") REFERENCES "UtmTemplate"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerGroupDefaultLink" ADD CONSTRAINT "PartnerGroupDefaultLink_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerGroupDefaultLink" ADD CONSTRAINT "PartnerGroupDefaultLink_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "PartnerGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Integration" ADD CONSTRAINT "Integration_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Integration" ADD CONSTRAINT "Integration_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InstalledIntegration" ADD CONSTRAINT "InstalledIntegration_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InstalledIntegration" ADD CONSTRAINT "InstalledIntegration_integrationId_fkey" FOREIGN KEY ("integrationId") REFERENCES "Integration"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InstalledIntegration" ADD CONSTRAINT "InstalledIntegration_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Invoice" ADD CONSTRAINT "Invoice_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Invoice" ADD CONSTRAINT "Invoice_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubmittedLead" ADD CONSTRAINT "SubmittedLead_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubmittedLead" ADD CONSTRAINT "SubmittedLead_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubmittedLead" ADD CONSTRAINT "SubmittedLead_programId_partnerId_fkey" FOREIGN KEY ("programId", "partnerId") REFERENCES "ProgramEnrollment"("programId", "partnerId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubmittedLead" ADD CONSTRAINT "SubmittedLead_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_folderId_fkey" FOREIGN KEY ("folderId") REFERENCES "Folder"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_domain_fkey" FOREIGN KEY ("domain") REFERENCES "Domain"("slug") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_programId_partnerId_fkey" FOREIGN KEY ("programId", "partnerId") REFERENCES "ProgramEnrollment"("programId", "partnerId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_partnerGroupDefaultLinkId_fkey" FOREIGN KEY ("partnerGroupDefaultLinkId") REFERENCES "PartnerGroupDefaultLink"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerLinkDetails" ADD CONSTRAINT "PartnerLinkDetails_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES "Link"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_senderUserId_fkey" FOREIGN KEY ("senderUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_senderPartnerId_fkey" FOREIGN KEY ("senderPartnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MessageAttachment" ADD CONSTRAINT "MessageAttachment_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "Message"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YearInReview" ADD CONSTRAINT "YearInReview_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerRewind" ADD CONSTRAINT "PartnerRewind_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramCategory" ADD CONSTRAINT "ProgramCategory_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramSimilarity" ADD CONSTRAINT "ProgramSimilarity_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramSimilarity" ADD CONSTRAINT "ProgramSimilarity_similarProgramId_fkey" FOREIGN KEY ("similarProgramId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DiscoveredPartner" ADD CONSTRAINT "DiscoveredPartner_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DiscoveredPartner" ADD CONSTRAINT "DiscoveredPartner_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DiscoveredPartner" ADD CONSTRAINT "DiscoveredPartner_programId_partnerId_fkey" FOREIGN KEY ("programId", "partnerId") REFERENCES "ProgramEnrollment"("programId", "partnerId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NotificationEmail" ADD CONSTRAINT "NotificationEmail_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "Message"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NotificationEmail" ADD CONSTRAINT "NotificationEmail_bountyId_fkey" FOREIGN KEY ("bountyId") REFERENCES "Bounty"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NotificationEmail" ADD CONSTRAINT "NotificationEmail_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "Campaign"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NotificationEmail" ADD CONSTRAINT "NotificationEmail_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserNotificationPreferences" ADD CONSTRAINT "UserNotificationPreferences_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NotificationPreference" ADD CONSTRAINT "NotificationPreference_projectUserId_fkey" FOREIGN KEY ("projectUserId") REFERENCES "ProjectUsers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerNotificationPreferences" ADD CONSTRAINT "PartnerNotificationPreferences_partnerUserId_fkey" FOREIGN KEY ("partnerUserId") REFERENCES "PartnerUser"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OAuthApp" ADD CONSTRAINT "OAuthApp_integrationId_fkey" FOREIGN KEY ("integrationId") REFERENCES "Integration"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OAuthCode" ADD CONSTRAINT "OAuthCode_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "OAuthApp"("clientId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OAuthCode" ADD CONSTRAINT "OAuthCode_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OAuthCode" ADD CONSTRAINT "OAuthCode_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OAuthRefreshToken" ADD CONSTRAINT "OAuthRefreshToken_accessTokenId_fkey" FOREIGN KEY ("accessTokenId") REFERENCES "RestrictedToken"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OAuthRefreshToken" ADD CONSTRAINT "OAuthRefreshToken_installationId_fkey" FOREIGN KEY ("installationId") REFERENCES "InstalledIntegration"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerInvite" ADD CONSTRAINT "PartnerInvite_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerUser" ADD CONSTRAINT "PartnerUser_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerUser" ADD CONSTRAINT "PartnerUser_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerIndustryInterest" ADD CONSTRAINT "PartnerIndustryInterest_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerPreferredEarningStructure" ADD CONSTRAINT "PartnerPreferredEarningStructure_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerSalesChannel" ADD CONSTRAINT "PartnerSalesChannel_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payout" ADD CONSTRAINT "Payout_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payout" ADD CONSTRAINT "Payout_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payout" ADD CONSTRAINT "Payout_programId_partnerId_fkey" FOREIGN KEY ("programId", "partnerId") REFERENCES "ProgramEnrollment"("programId", "partnerId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payout" ADD CONSTRAINT "Payout_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "Invoice"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payout" ADD CONSTRAINT "Payout_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerPlatform" ADD CONSTRAINT "PartnerPlatform_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Postback" ADD CONSTRAINT "Postback_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Program" ADD CONSTRAINT "Program_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Program" ADD CONSTRAINT "Program_domain_fkey" FOREIGN KEY ("domain") REFERENCES "Domain"("slug") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramEnrollment" ADD CONSTRAINT "ProgramEnrollment_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramEnrollment" ADD CONSTRAINT "ProgramEnrollment_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramEnrollment" ADD CONSTRAINT "ProgramEnrollment_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "PartnerGroup"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramEnrollment" ADD CONSTRAINT "ProgramEnrollment_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES "ProgramApplication"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramEnrollment" ADD CONSTRAINT "ProgramEnrollment_clickRewardId_fkey" FOREIGN KEY ("clickRewardId") REFERENCES "Reward"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramEnrollment" ADD CONSTRAINT "ProgramEnrollment_leadRewardId_fkey" FOREIGN KEY ("leadRewardId") REFERENCES "Reward"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramEnrollment" ADD CONSTRAINT "ProgramEnrollment_saleRewardId_fkey" FOREIGN KEY ("saleRewardId") REFERENCES "Reward"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramEnrollment" ADD CONSTRAINT "ProgramEnrollment_referralRewardId_fkey" FOREIGN KEY ("referralRewardId") REFERENCES "Reward"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramEnrollment" ADD CONSTRAINT "ProgramEnrollment_customRewardId_fkey" FOREIGN KEY ("customRewardId") REFERENCES "Reward"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramEnrollment" ADD CONSTRAINT "ProgramEnrollment_discountId_fkey" FOREIGN KEY ("discountId") REFERENCES "Discount"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reward" ADD CONSTRAINT "Reward_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reward" ADD CONSTRAINT "Reward_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "PartnerGroup"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "LinkReward" ADD CONSTRAINT "LinkReward_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES "Link"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LinkReward" ADD CONSTRAINT "LinkReward_clickRewardId_fkey" FOREIGN KEY ("clickRewardId") REFERENCES "Reward"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LinkReward" ADD CONSTRAINT "LinkReward_leadRewardId_fkey" FOREIGN KEY ("leadRewardId") REFERENCES "Reward"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LinkReward" ADD CONSTRAINT "LinkReward_saleRewardId_fkey" FOREIGN KEY ("saleRewardId") REFERENCES "Reward"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LinkReward" ADD CONSTRAINT "LinkReward_discountId_fkey" FOREIGN KEY ("discountId") REFERENCES "Discount"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Session" ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tag" ADD CONSTRAINT "Tag_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LinkTag" ADD CONSTRAINT "LinkTag_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES "Link"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LinkTag" ADD CONSTRAINT "LinkTag_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartnerTag" ADD CONSTRAINT "PartnerTag_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramPartnerTag" ADD CONSTRAINT "ProgramPartnerTag_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramPartnerTag" ADD CONSTRAINT "ProgramPartnerTag_programId_partnerId_fkey" FOREIGN KEY ("programId", "partnerId") REFERENCES "ProgramEnrollment"("programId", "partnerId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramPartnerTag" ADD CONSTRAINT "ProgramPartnerTag_partnerTagId_fkey" FOREIGN KEY ("partnerTagId") REFERENCES "PartnerTag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProgramPartnerTag" ADD CONSTRAINT "ProgramPartnerTag_partnerId_fkey" FOREIGN KEY ("partnerId") REFERENCES "Partner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Token" ADD CONSTRAINT "Token_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RestrictedToken" ADD CONSTRAINT "RestrictedToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RestrictedToken" ADD CONSTRAINT "RestrictedToken_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RestrictedToken" ADD CONSTRAINT "RestrictedToken_installationId_fkey" FOREIGN KEY ("installationId") REFERENCES "InstalledIntegration"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UtmTemplate" ADD CONSTRAINT "UtmTemplate_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UtmTemplate" ADD CONSTRAINT "UtmTemplate_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Webhook" ADD CONSTRAINT "Webhook_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Webhook" ADD CONSTRAINT "Webhook_installationId_fkey" FOREIGN KEY ("installationId") REFERENCES "InstalledIntegration"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LinkWebhook" ADD CONSTRAINT "LinkWebhook_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES "Link"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LinkWebhook" ADD CONSTRAINT "LinkWebhook_webhookId_fkey" FOREIGN KEY ("webhookId") REFERENCES "Webhook"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FolderWebhook" ADD CONSTRAINT "FolderWebhook_folderId_fkey" FOREIGN KEY ("folderId") REFERENCES "Folder"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FolderWebhook" ADD CONSTRAINT "FolderWebhook_webhookId_fkey" FOREIGN KEY ("webhookId") REFERENCES "Webhook"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Workflow" ADD CONSTRAINT "Workflow_programId_fkey" FOREIGN KEY ("programId") REFERENCES "Program"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectInvite" ADD CONSTRAINT "ProjectInvite_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectUsers" ADD CONSTRAINT "ProjectUsers_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectUsers" ADD CONSTRAINT "ProjectUsers_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SentEmail" ADD CONSTRAINT "SentEmail_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;
