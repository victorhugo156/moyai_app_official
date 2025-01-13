import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";
import multer from "multer";

const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

const bucketRegion: string = process.env.BUCKET_REGION || "";
const accessKey: string = process.env.S3_ACCESS_KEY || "";
const secretAccessKey: string = process.env.S3_SECRET_ACCESS_KEY || "";

const s3 = new S3Client({
  credentials: {
    accessKeyId: accessKey,
    secretAccessKey: secretAccessKey,
  },
  region: bucketRegion,
});

async function uploadImage(
  bucketName: string,
  key: string,
  buffer: Buffer,
  contentType: string
): Promise<string | null> {
  const params = {
    Bucket: bucketName,
    Key: key,
    Body: buffer,
    ContentType: contentType,
  };

  console.log(params);

  try {
    const command = new PutObjectCommand(params);
    await s3.send(command);
    return `https://${bucketName}.s3.${bucketRegion}.amazonaws.com/${key}`;
  } catch (error) {
    return null;
  }
}

export { upload, uploadImage };
