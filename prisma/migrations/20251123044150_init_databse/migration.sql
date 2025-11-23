-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM ('INVOICE', 'EXPENSE', 'INCOME', 'TRANSFER');

-- CreateEnum
CREATE TYPE "RoleType" AS ENUM ('OWNER', 'ACCOUNTANT', 'STAFF', 'VIEWER');

-- CreateEnum
CREATE TYPE "AccountType" AS ENUM ('ASSETS', 'LIABILITY', 'EQUITY', 'INCOME', 'EXPENSE');

-- CreateEnum
CREATE TYPE "ReferenceType" AS ENUM ('INVOICE', 'INCOME_TRANSACTION', 'EXPENSE_TRANSACTION', 'TRANSFER_TRANSACTION', 'BILL', 'NONE');

-- CreateEnum
CREATE TYPE "RecurringInterval" AS ENUM ('DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY');

-- CreateTable
CREATE TABLE "Users" (
    "id" SERIAL NOT NULL,
    "name" TEXT,
    "email" TEXT NOT NULL,
    "password" TEXT,
    "phone" TEXT,
    "fcmToken" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Companies" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT,
    "ownerId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Companies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserCompany" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "companyId" INTEGER NOT NULL,
    "role" "RoleType" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserCompany_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Accounts" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT,
    "type" "AccountType" NOT NULL,
    "isDefault" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "JournalEntries" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "description" TEXT,
    "transactionType" "TransactionType" NOT NULL,
    "referenceType" "ReferenceType" NOT NULL DEFAULT 'NONE',
    "referenceId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "JournalEntries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "JournalLines" (
    "id" SERIAL NOT NULL,
    "journalEntryId" INTEGER NOT NULL,
    "accountId" INTEGER NOT NULL,
    "debit" DECIMAL(20,2) NOT NULL,
    "credit" DECIMAL(20,2) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "JournalLines_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Customers" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT,
    "phone" TEXT,
    "address" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Customers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Vendors" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT,
    "phone" TEXT,
    "address" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Vendors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Invoices" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "customerId" INTEGER NOT NULL,
    "invoiceNumber" TEXT,
    "date" TIMESTAMP(3) NOT NULL,
    "dueDate" TIMESTAMP(3),
    "status" TEXT NOT NULL,
    "subtotal" DECIMAL(20,2) NOT NULL,
    "total" DECIMAL(20,2) NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Invoices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InvoiceItems" (
    "id" SERIAL NOT NULL,
    "invoiceId" INTEGER NOT NULL,
    "productId" INTEGER,
    "description" TEXT,
    "quantity" DECIMAL(20,4) NOT NULL,
    "price" DECIMAL(20,2) NOT NULL,
    "incomeAccountId" INTEGER NOT NULL,

    CONSTRAINT "InvoiceItems_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InvoicePayments" (
    "id" SERIAL NOT NULL,
    "invoiceId" INTEGER NOT NULL,
    "accountId" INTEGER NOT NULL,
    "amount" DECIMAL(20,2) NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "InvoicePayments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IncomeTransactions" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "accountId" INTEGER NOT NULL,
    "incomeAccountId" INTEGER NOT NULL,
    "customerId" INTEGER,
    "amount" DECIMAL(20,2) NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "IncomeTransactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ExpenseTransactions" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "accountId" INTEGER NOT NULL,
    "expenseAccountId" INTEGER NOT NULL,
    "vendorId" INTEGER,
    "amount" DECIMAL(20,2) NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ExpenseTransactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TransferTransactions" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "fromAccountId" INTEGER NOT NULL,
    "toAccountId" INTEGER NOT NULL,
    "amount" DECIMAL(20,2) NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TransferTransactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Products" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "price" DECIMAL(20,2) NOT NULL,
    "incomeAccountId" INTEGER,
    "expenseAccountId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RecurringInvoices" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "customerId" INTEGER NOT NULL,
    "interval" "RecurringInterval" NOT NULL,
    "nextRun" TIMESTAMP(3) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RecurringInvoices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Bills" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "vendorId" INTEGER NOT NULL,
    "billNumber" TEXT,
    "date" TIMESTAMP(3) NOT NULL,
    "dueDate" TIMESTAMP(3),
    "total" DECIMAL(20,2) NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Bills_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BillItems" (
    "id" SERIAL NOT NULL,
    "billId" INTEGER NOT NULL,
    "description" TEXT,
    "quantity" DECIMAL(20,4) NOT NULL,
    "price" DECIMAL(20,2) NOT NULL,
    "expenseAccountId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BillItems_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BillPayments" (
    "id" SERIAL NOT NULL,
    "billId" INTEGER NOT NULL,
    "accountId" INTEGER NOT NULL,
    "amount" DECIMAL(20,2) NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BillPayments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Attachments" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "targetTable" TEXT NOT NULL,
    "targetId" INTEGER NOT NULL,
    "fileUrl" TEXT NOT NULL,
    "fileName" TEXT,
    "mimeType" TEXT,
    "size" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Attachments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditLogs" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "userId" INTEGER,
    "action" TEXT NOT NULL,
    "tableName" TEXT NOT NULL,
    "recordId" INTEGER,
    "oldValue" JSONB,
    "newValue" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLogs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Invitations" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "companyId" INTEGER NOT NULL,
    "role" "RoleType" NOT NULL,
    "token" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "accepted" BOOLEAN NOT NULL DEFAULT false,
    "invitedBy" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Invitations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Boards" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "createdBy" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Boards_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BoardNodes" (
    "id" SERIAL NOT NULL,
    "boardId" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "data" JSONB,
    "x" DOUBLE PRECISION NOT NULL,
    "y" DOUBLE PRECISION NOT NULL,
    "width" DOUBLE PRECISION,
    "height" DOUBLE PRECISION,
    "rotation" DOUBLE PRECISION,
    "color" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BoardNodes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BoardEdges" (
    "id" SERIAL NOT NULL,
    "boardId" INTEGER NOT NULL,
    "fromNodeId" INTEGER NOT NULL,
    "toNodeId" INTEGER NOT NULL,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BoardEdges_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BoardPermissions" (
    "id" SERIAL NOT NULL,
    "boardId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "canView" BOOLEAN NOT NULL DEFAULT true,
    "canEdit" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BoardPermissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_CompaniesToJournalLines" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,

    CONSTRAINT "_CompaniesToJournalLines_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateTable
CREATE TABLE "_CompaniesToInvoiceItems" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,

    CONSTRAINT "_CompaniesToInvoiceItems_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateTable
CREATE TABLE "_CompaniesToInvoicePayments" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,

    CONSTRAINT "_CompaniesToInvoicePayments_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateTable
CREATE TABLE "_BillItemsToCompanies" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,

    CONSTRAINT "_BillItemsToCompanies_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateTable
CREATE TABLE "_BillPaymentsToCompanies" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,

    CONSTRAINT "_BillPaymentsToCompanies_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "Users_email_key" ON "Users"("email");

-- CreateIndex
CREATE INDEX "UserCompany_userId_idx" ON "UserCompany"("userId");

-- CreateIndex
CREATE INDEX "UserCompany_companyId_idx" ON "UserCompany"("companyId");

-- CreateIndex
CREATE INDEX "Accounts_companyId_idx" ON "Accounts"("companyId");

-- CreateIndex
CREATE INDEX "Accounts_code_idx" ON "Accounts"("code");

-- CreateIndex
CREATE INDEX "JournalEntries_companyId_idx" ON "JournalEntries"("companyId");

-- CreateIndex
CREATE INDEX "JournalEntries_date_idx" ON "JournalEntries"("date");

-- CreateIndex
CREATE INDEX "JournalLines_journalEntryId_idx" ON "JournalLines"("journalEntryId");

-- CreateIndex
CREATE INDEX "JournalLines_accountId_idx" ON "JournalLines"("accountId");

-- CreateIndex
CREATE INDEX "Customers_companyId_idx" ON "Customers"("companyId");

-- CreateIndex
CREATE INDEX "Vendors_companyId_idx" ON "Vendors"("companyId");

-- CreateIndex
CREATE INDEX "Invoices_companyId_idx" ON "Invoices"("companyId");

-- CreateIndex
CREATE INDEX "Invoices_customerId_idx" ON "Invoices"("customerId");

-- CreateIndex
CREATE INDEX "Invoices_invoiceNumber_idx" ON "Invoices"("invoiceNumber");

-- CreateIndex
CREATE INDEX "InvoiceItems_invoiceId_idx" ON "InvoiceItems"("invoiceId");

-- CreateIndex
CREATE INDEX "InvoiceItems_productId_idx" ON "InvoiceItems"("productId");

-- CreateIndex
CREATE INDEX "InvoiceItems_incomeAccountId_idx" ON "InvoiceItems"("incomeAccountId");

-- CreateIndex
CREATE INDEX "InvoicePayments_invoiceId_idx" ON "InvoicePayments"("invoiceId");

-- CreateIndex
CREATE INDEX "InvoicePayments_accountId_idx" ON "InvoicePayments"("accountId");

-- CreateIndex
CREATE INDEX "IncomeTransactions_companyId_idx" ON "IncomeTransactions"("companyId");

-- CreateIndex
CREATE INDEX "IncomeTransactions_accountId_idx" ON "IncomeTransactions"("accountId");

-- CreateIndex
CREATE INDEX "IncomeTransactions_incomeAccountId_idx" ON "IncomeTransactions"("incomeAccountId");

-- CreateIndex
CREATE INDEX "ExpenseTransactions_companyId_idx" ON "ExpenseTransactions"("companyId");

-- CreateIndex
CREATE INDEX "ExpenseTransactions_accountId_idx" ON "ExpenseTransactions"("accountId");

-- CreateIndex
CREATE INDEX "ExpenseTransactions_expenseAccountId_idx" ON "ExpenseTransactions"("expenseAccountId");

-- CreateIndex
CREATE INDEX "TransferTransactions_companyId_idx" ON "TransferTransactions"("companyId");

-- CreateIndex
CREATE INDEX "TransferTransactions_fromAccountId_idx" ON "TransferTransactions"("fromAccountId");

-- CreateIndex
CREATE INDEX "TransferTransactions_toAccountId_idx" ON "TransferTransactions"("toAccountId");

-- CreateIndex
CREATE INDEX "Products_companyId_idx" ON "Products"("companyId");

-- CreateIndex
CREATE INDEX "RecurringInvoices_companyId_idx" ON "RecurringInvoices"("companyId");

-- CreateIndex
CREATE INDEX "RecurringInvoices_customerId_idx" ON "RecurringInvoices"("customerId");

-- CreateIndex
CREATE INDEX "Bills_companyId_idx" ON "Bills"("companyId");

-- CreateIndex
CREATE INDEX "Bills_vendorId_idx" ON "Bills"("vendorId");

-- CreateIndex
CREATE INDEX "BillItems_billId_idx" ON "BillItems"("billId");

-- CreateIndex
CREATE INDEX "BillItems_expenseAccountId_idx" ON "BillItems"("expenseAccountId");

-- CreateIndex
CREATE INDEX "BillPayments_billId_idx" ON "BillPayments"("billId");

-- CreateIndex
CREATE INDEX "BillPayments_accountId_idx" ON "BillPayments"("accountId");

-- CreateIndex
CREATE INDEX "Attachments_companyId_idx" ON "Attachments"("companyId");

-- CreateIndex
CREATE INDEX "Attachments_targetTable_targetId_idx" ON "Attachments"("targetTable", "targetId");

-- CreateIndex
CREATE INDEX "AuditLogs_companyId_idx" ON "AuditLogs"("companyId");

-- CreateIndex
CREATE INDEX "AuditLogs_tableName_idx" ON "AuditLogs"("tableName");

-- CreateIndex
CREATE UNIQUE INDEX "Invitations_token_key" ON "Invitations"("token");

-- CreateIndex
CREATE INDEX "Invitations_companyId_idx" ON "Invitations"("companyId");

-- CreateIndex
CREATE INDEX "Invitations_email_idx" ON "Invitations"("email");

-- CreateIndex
CREATE INDEX "Boards_companyId_idx" ON "Boards"("companyId");

-- CreateIndex
CREATE INDEX "BoardNodes_boardId_idx" ON "BoardNodes"("boardId");

-- CreateIndex
CREATE INDEX "BoardEdges_boardId_idx" ON "BoardEdges"("boardId");

-- CreateIndex
CREATE INDEX "BoardEdges_fromNodeId_idx" ON "BoardEdges"("fromNodeId");

-- CreateIndex
CREATE INDEX "BoardEdges_toNodeId_idx" ON "BoardEdges"("toNodeId");

-- CreateIndex
CREATE INDEX "BoardPermissions_boardId_idx" ON "BoardPermissions"("boardId");

-- CreateIndex
CREATE INDEX "BoardPermissions_userId_idx" ON "BoardPermissions"("userId");

-- CreateIndex
CREATE INDEX "_CompaniesToJournalLines_B_index" ON "_CompaniesToJournalLines"("B");

-- CreateIndex
CREATE INDEX "_CompaniesToInvoiceItems_B_index" ON "_CompaniesToInvoiceItems"("B");

-- CreateIndex
CREATE INDEX "_CompaniesToInvoicePayments_B_index" ON "_CompaniesToInvoicePayments"("B");

-- CreateIndex
CREATE INDEX "_BillItemsToCompanies_B_index" ON "_BillItemsToCompanies"("B");

-- CreateIndex
CREATE INDEX "_BillPaymentsToCompanies_B_index" ON "_BillPaymentsToCompanies"("B");

-- AddForeignKey
ALTER TABLE "Companies" ADD CONSTRAINT "Companies_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserCompany" ADD CONSTRAINT "UserCompany_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserCompany" ADD CONSTRAINT "UserCompany_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Accounts" ADD CONSTRAINT "Accounts_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JournalEntries" ADD CONSTRAINT "JournalEntries_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JournalLines" ADD CONSTRAINT "JournalLines_journalEntryId_fkey" FOREIGN KEY ("journalEntryId") REFERENCES "JournalEntries"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JournalLines" ADD CONSTRAINT "JournalLines_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Customers" ADD CONSTRAINT "Customers_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vendors" ADD CONSTRAINT "Vendors_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Invoices" ADD CONSTRAINT "Invoices_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Invoices" ADD CONSTRAINT "Invoices_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InvoiceItems" ADD CONSTRAINT "InvoiceItems_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "Invoices"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InvoiceItems" ADD CONSTRAINT "InvoiceItems_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Products"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InvoiceItems" ADD CONSTRAINT "InvoiceItems_incomeAccountId_fkey" FOREIGN KEY ("incomeAccountId") REFERENCES "Accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InvoicePayments" ADD CONSTRAINT "InvoicePayments_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "Invoices"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InvoicePayments" ADD CONSTRAINT "InvoicePayments_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IncomeTransactions" ADD CONSTRAINT "IncomeTransactions_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IncomeTransactions" ADD CONSTRAINT "IncomeTransactions_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IncomeTransactions" ADD CONSTRAINT "IncomeTransactions_incomeAccountId_fkey" FOREIGN KEY ("incomeAccountId") REFERENCES "Accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IncomeTransactions" ADD CONSTRAINT "IncomeTransactions_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExpenseTransactions" ADD CONSTRAINT "ExpenseTransactions_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExpenseTransactions" ADD CONSTRAINT "ExpenseTransactions_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExpenseTransactions" ADD CONSTRAINT "ExpenseTransactions_expenseAccountId_fkey" FOREIGN KEY ("expenseAccountId") REFERENCES "Accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExpenseTransactions" ADD CONSTRAINT "ExpenseTransactions_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "Vendors"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TransferTransactions" ADD CONSTRAINT "TransferTransactions_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TransferTransactions" ADD CONSTRAINT "TransferTransactions_fromAccountId_fkey" FOREIGN KEY ("fromAccountId") REFERENCES "Accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TransferTransactions" ADD CONSTRAINT "TransferTransactions_toAccountId_fkey" FOREIGN KEY ("toAccountId") REFERENCES "Accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Products" ADD CONSTRAINT "Products_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Products" ADD CONSTRAINT "Products_incomeAccountId_fkey" FOREIGN KEY ("incomeAccountId") REFERENCES "Accounts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Products" ADD CONSTRAINT "Products_expenseAccountId_fkey" FOREIGN KEY ("expenseAccountId") REFERENCES "Accounts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RecurringInvoices" ADD CONSTRAINT "RecurringInvoices_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RecurringInvoices" ADD CONSTRAINT "RecurringInvoices_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bills" ADD CONSTRAINT "Bills_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bills" ADD CONSTRAINT "Bills_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "Vendors"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BillItems" ADD CONSTRAINT "BillItems_billId_fkey" FOREIGN KEY ("billId") REFERENCES "Bills"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BillItems" ADD CONSTRAINT "BillItems_expenseAccountId_fkey" FOREIGN KEY ("expenseAccountId") REFERENCES "Accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BillPayments" ADD CONSTRAINT "BillPayments_billId_fkey" FOREIGN KEY ("billId") REFERENCES "Bills"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BillPayments" ADD CONSTRAINT "BillPayments_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Attachments" ADD CONSTRAINT "Attachments_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditLogs" ADD CONSTRAINT "AuditLogs_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditLogs" ADD CONSTRAINT "AuditLogs_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Invitations" ADD CONSTRAINT "Invitations_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Invitations" ADD CONSTRAINT "Invitations_invitedBy_fkey" FOREIGN KEY ("invitedBy") REFERENCES "Users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Boards" ADD CONSTRAINT "Boards_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Boards" ADD CONSTRAINT "Boards_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "Users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BoardNodes" ADD CONSTRAINT "BoardNodes_boardId_fkey" FOREIGN KEY ("boardId") REFERENCES "Boards"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BoardEdges" ADD CONSTRAINT "BoardEdges_boardId_fkey" FOREIGN KEY ("boardId") REFERENCES "Boards"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BoardEdges" ADD CONSTRAINT "BoardEdges_fromNodeId_fkey" FOREIGN KEY ("fromNodeId") REFERENCES "BoardNodes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BoardEdges" ADD CONSTRAINT "BoardEdges_toNodeId_fkey" FOREIGN KEY ("toNodeId") REFERENCES "BoardNodes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BoardPermissions" ADD CONSTRAINT "BoardPermissions_boardId_fkey" FOREIGN KEY ("boardId") REFERENCES "Boards"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BoardPermissions" ADD CONSTRAINT "BoardPermissions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CompaniesToJournalLines" ADD CONSTRAINT "_CompaniesToJournalLines_A_fkey" FOREIGN KEY ("A") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CompaniesToJournalLines" ADD CONSTRAINT "_CompaniesToJournalLines_B_fkey" FOREIGN KEY ("B") REFERENCES "JournalLines"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CompaniesToInvoiceItems" ADD CONSTRAINT "_CompaniesToInvoiceItems_A_fkey" FOREIGN KEY ("A") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CompaniesToInvoiceItems" ADD CONSTRAINT "_CompaniesToInvoiceItems_B_fkey" FOREIGN KEY ("B") REFERENCES "InvoiceItems"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CompaniesToInvoicePayments" ADD CONSTRAINT "_CompaniesToInvoicePayments_A_fkey" FOREIGN KEY ("A") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CompaniesToInvoicePayments" ADD CONSTRAINT "_CompaniesToInvoicePayments_B_fkey" FOREIGN KEY ("B") REFERENCES "InvoicePayments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BillItemsToCompanies" ADD CONSTRAINT "_BillItemsToCompanies_A_fkey" FOREIGN KEY ("A") REFERENCES "BillItems"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BillItemsToCompanies" ADD CONSTRAINT "_BillItemsToCompanies_B_fkey" FOREIGN KEY ("B") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BillPaymentsToCompanies" ADD CONSTRAINT "_BillPaymentsToCompanies_A_fkey" FOREIGN KEY ("A") REFERENCES "BillPayments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BillPaymentsToCompanies" ADD CONSTRAINT "_BillPaymentsToCompanies_B_fkey" FOREIGN KEY ("B") REFERENCES "Companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;
