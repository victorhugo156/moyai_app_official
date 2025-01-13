import { Request } from "express";

// func to extract accessToken from the header and return as string
// returns an empty string if nothing was in header
export function extractToken(req: Request): string {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1]; // Extract token part
  return token || "";
}
