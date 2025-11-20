import { jwtVerify, SignJWT } from "jose";
import { TokenPayload } from "./types.js";

export async function createJWT(payload: TokenPayload) {
  const secret = new TextEncoder().encode(
    process.env.JWT_SECRET || "default_secret"
  );

  return await new SignJWT(payload)
    .setProtectedHeader({ alg: "HS256" })
    .setIssuedAt()
    .setExpirationTime(process.env.JWT_EXPIRATION || "7d")
    .sign(secret);
}

export async function verifyJWT(token: string) {
  const secret = new TextEncoder().encode(
    process.env.JWT_SECRET || "default_secret"
  );
  try {
    const { payload } = await jwtVerify(token, secret);
    return payload as TokenPayload;
  } catch (err) {
    console.error("JWT verification failed:", err);
    return null;
  }
}
