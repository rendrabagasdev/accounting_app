import React from "react";

export default function Button(
  props: React.ButtonHTMLAttributes<HTMLButtonElement>
) {
  const { children, className = "", ...rest } = props;

  return (
    <button
      className={`p-2 rounded-xl border bg-(--color-accent) hover:bg-(--color-accent-hover) text-(--text-on-primary) active:scale-95 transition ${className}`}
      {...rest}
    >
      {children}
    </button>
  );
}
