import image from '@ohos.multimedia.image';

export class ImageResourceManager {
  private static instance: ImageResourceManager | null = null;
  private cache: Map<string, image.PixelMap> = new Map();

  static getInstance(): ImageResourceManager {
    if (!ImageResourceManager.instance) {
      ImageResourceManager.instance = new ImageResourceManager();
    }
    return ImageResourceManager.instance;
  }

  async preload(): Promise<void> {
  }

  getImage(path: string): image.PixelMap | null {
    const cached = this.cache.get(path);
    if (cached) {
      return cached;
    }
    return null;
  }

  putImage(path: string, pixelMap: image.PixelMap): void {
    this.cache.set(path, pixelMap);
  }

  release(): void {
    this.cache.forEach((pixelMap: image.PixelMap) => {
      pixelMap.release();
    });
    this.cache.clear();
  }
}
