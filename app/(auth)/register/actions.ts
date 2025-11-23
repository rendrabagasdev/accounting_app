"use server";

import z from "zod";
import { registerSchema } from "./schema";

export async function registerAction(formData: FormData) {
  const data = registerSchema.safeParse({
    name: formData.get("name"),
    email: formData.get("email"),
    password: formData.get("password"),
  });

  if (!data.success) {
    const errors = z.treeifyError(data.error);
    return { errors };
  }
}
