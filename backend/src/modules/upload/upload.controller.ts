import {
  Controller, Post, UseGuards, UseInterceptors,
  UploadedFile, UploadedFiles, BadRequestException,
} from '@nestjs/common';
import { FileInterceptor, FilesInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname, join } from 'path';
import { v4 as uuidv4 } from 'uuid';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';

const UPLOAD_DIR = join(process.cwd(), 'uploads');

const storage = diskStorage({
  destination: (_req: any, _file: any, cb: any) => cb(null, UPLOAD_DIR),
  filename: (_req: any, file: any, cb: any) => {
    const id = uuidv4();
    const ext = extname(file.originalname);
    cb(null, `${id}${ext}`);
  },
});

const imageFilter = (_req: any, file: any, cb: any) => {
  if (!file.mimetype.match(/^image\/(jpeg|png|gif|webp)$/)) {
    return cb(new BadRequestException('Only JPEG, PNG, GIF, and WebP images are allowed'), false);
  }
  cb(null, true);
};

const videoFilter = (_req: any, file: any, cb: any) => {
  if (!file.mimetype.match(/^video\/(mp4|quicktime|x-msvideo|x-ms-wmv)$/)) {
    return cb(new BadRequestException('Only MP4, MOV, AVI, and WMV videos are allowed'), false);
  }
  cb(null, true);
};

@Controller('upload')
@UseGuards(JwtAuthGuard)
export class UploadController {
  private readonly baseUrl = process.env.UPLOAD_BASE_URL || 'http://localhost:3000/uploads';

  @Post('avatar')
  @UseInterceptors(FileInterceptor('file', { storage, fileFilter: imageFilter, limits: { fileSize: 5 * 1024 * 1024 } }))
  uploadAvatar(@UploadedFile() file: any) {
    return { url: `${this.baseUrl}/${file.filename}`, filename: file.filename };
  }

  @Post('photos')
  @UseInterceptors(FilesInterceptor('files', 5, { storage, fileFilter: imageFilter, limits: { fileSize: 10 * 1024 * 1024 } }))
  uploadPhotos(@UploadedFiles() files: any[]) {
    const urls = files.map((f) => ({ url: `${this.baseUrl}/${f.filename}`, filename: f.filename }));
    return { files: urls };
  }

  @Post('videos')
  @UseInterceptors(FileInterceptor('file', { storage, fileFilter: videoFilter, limits: { fileSize: 200 * 1024 * 1024 } }))
  uploadVideo(@UploadedFile() file: any) {
    return { url: `${this.baseUrl}/${file.filename}`, filename: file.filename };
  }

  @Post('badge')
  @UseInterceptors(FileInterceptor('file', { storage, fileFilter: imageFilter, limits: { fileSize: 5 * 1024 * 1024 } }))
  uploadBadge(@UploadedFile() file: any) {
    return { url: `${this.baseUrl}/${file.filename}`, filename: file.filename };
  }

  @Post('banner')
  @UseInterceptors(FileInterceptor('file', { storage, fileFilter: imageFilter, limits: { fileSize: 10 * 1024 * 1024 } }))
  uploadBanner(@UploadedFile() file: any) {
    return { url: `${this.baseUrl}/${file.filename}`, filename: file.filename };
  }
}
