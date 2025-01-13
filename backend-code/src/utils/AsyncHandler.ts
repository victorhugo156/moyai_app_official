import { Request, Response, NextFunction } from "express";
import ApiError from "./ApiError.js";

const asyncHandler = (
  func: (req: Request, res: Response, next: NextFunction) => Promise<void>
) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      await func(req, res, next);
    } catch (error) {
      const statusCode = error instanceof ApiError ? error.statusCode : 500;
      const message =
        error instanceof ApiError ? error.message : "Internal Server Error";

      res.status(statusCode).json({
        success: false,
        message,
      });
    }
  };
};

export { asyncHandler };
