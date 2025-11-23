"use client";

import Image from "next/image";
import React from "react";

export default function AuthLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="grid min-h-screen grid-cols-1 md:grid-cols-2 bg-background ">
      <div className="flex items-center justify-center p-8 bg-">{children}</div>
      <div className="hidden relative lg:block">
        <Image
          src="/images/auth.jpeg"
          alt="Auth Ilustrasion"
          fill
          className="object-contain"
        />
      </div>
    </div>
  );
}
