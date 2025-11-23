import Button from "@/lib/components/button";
import Input from "@/lib/components/input";

export default function RegisterForm() {
  return (
    <form className="p-6 rounded-xl w-full shadow-md">
      <h1 className="text-2xl font-semibold mb-4 text-center">Register Form</h1>
      {/* Form fields will go here */}
      <div className="flex flex-col p-2">
        <label htmlFor="name">Name</label>
        <Input type="text" id="name" />
      </div>
      <div className="flex flex-col p-2">
        <label htmlFor="email">Email</label>
        <Input type="email" id="email" />
      </div>
      <div className="flex flex-col p-2">
        <label htmlFor="password">Password</label>
        <Input />
      </div>
      <div className="flex flex-col p-2">
        <Button className=""> HALO HA </Button>
      </div>
    </form>
  );
}
