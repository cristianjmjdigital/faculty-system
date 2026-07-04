import mysql from "mysql2/promise";

declare global {
  // eslint-disable-next-line no-var
  var __facultyMysqlPool: mysql.Pool | undefined;
}

let pool: mysql.Pool | null = globalThis.__facultyMysqlPool ?? null;

function requiredEnv(name: string, fallback?: string): string {
  const value = process.env[name] ?? fallback;
  if (!value) {
    throw new Error(`Missing required env var: ${name}`);
  }
  return value;
}

export function getMysqlPool() {
  if (pool) return pool;

  pool = mysql.createPool({
    host: requiredEnv("MYSQL_HOST", "127.0.0.1"),
    port: Number(requiredEnv("MYSQL_PORT", "3306")),
    user: requiredEnv("MYSQL_USER", "root"),
    password: process.env.MYSQL_PASSWORD ?? "",
    database: requiredEnv("MYSQL_DATABASE", "faculty-db"),
    waitForConnections: true,
    connectionLimit: 20,
    queueLimit: 0,
  });

  globalThis.__facultyMysqlPool = pool;

  return pool;
}

