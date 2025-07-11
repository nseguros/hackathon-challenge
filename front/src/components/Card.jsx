"use client"

const Card = ({ children, className = "", onClick, ...props }) => {
  return (
    <div
      className={`card ${onClick ? "cursor-pointer hover:shadow-xl transition-all duration-300 hover:scale-105" : ""} ${className}`}
      onClick={onClick}
      {...props}
    >
      {children}
    </div>
  )
}

export const CardHeader = ({ children, className = "" }) => <div className={`p-6 pb-4 ${className}`}>{children}</div>

export const CardContent = ({ children, className = "" }) => <div className={`p-6 pt-0 ${className}`}>{children}</div>

export const CardTitle = ({ children, className = "" }) => (
  <h3 className={`text-lg font-semibold ${className}`}>{children}</h3>
)

export default Card
