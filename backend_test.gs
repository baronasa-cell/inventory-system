/**
 * 統合管理システム - バックエンドAPI (Google Apps Script)
 * VERSION: 0.4
 */

const SS = SpreadsheetApp.getActiveSpreadsheet();
const AUTH_KEY = 'inventory-api-auth-8k2p9m';

/**
 * POSTリクエストの処理
 */
function doPost(e) {
  const lock = LockService.getScriptLock();
  try {
    lock.waitLock(30000);
    const p = JSON.parse(e.postData.contents);
    if (p.key !== AUTH_KEY) {
      return ContentService.createTextOutput(JSON.stringify({ status: 'error', message: 'Unauthorized: Invalid API Key' })).setMimeType(ContentService.MimeType.JSON);
    }
    const action = p.action;
    // ...修復中...
