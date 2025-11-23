import { RegisterSchema } from "./schema";
import prisma from "@/lib/database/prisma";

export const registerDal = {
  async create(data: RegisterSchema) {
    try {
      const { name, email, password } = data;
      await prisma.users.create({
        data: {
          name,
          email,
          password,
        },
      });
    } catch (error) {
      console.log("Error creating user:", error);
      return error;
    }
  },
};
