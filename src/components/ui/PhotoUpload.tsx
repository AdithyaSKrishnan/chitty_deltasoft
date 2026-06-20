import { useState, useRef } from 'react';
import { Upload, X, Image as ImageIcon, FileText, MapPin } from 'lucide-react';

interface PhotoUploadProps {
  type: 'customer' | 'address_proof' | 'id_proof' | 'work_location';
  label: string;
  value?: string;
  onChange: (url: string) => void;
  compact?: boolean;
}

const icons = {
  customer: ImageIcon,
  address_proof: FileText,
  id_proof: FileText,
  work_location: MapPin,
};

export function PhotoUpload({ type, label, value, onChange, compact = false }: PhotoUploadProps) {
  const [isDragging, setIsDragging] = useState(false);
  const [preview, setPreview] = useState<string | null>(value || null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const Icon = icons[type];

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(true);
  };

  const handleDragLeave = () => {
    setIsDragging(false);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
    const file = e.dataTransfer.files[0];
    if (file && file.type.startsWith('image/')) {
      handleFile(file);
    }
  };

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      handleFile(file);
    }
  };

  const handleFile = (file: File) => {
    const reader = new FileReader();
    reader.onloadend = () => {
      const result = reader.result as string;
      setPreview(result);
      onChange(result);
    };
    reader.readAsDataURL(file);
  };

  const handleRemove = () => {
    setPreview(null);
    onChange('');
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  if (compact) {
    return (
      <div className="relative">
        <input
          ref={fileInputRef}
          type="file"
          accept="image/*"
          onChange={handleFileSelect}
          className="hidden"
        />
        {preview ? (
          <div className="relative aspect-square rounded-xl overflow-hidden bg-slate-100 dark:bg-slate-700">
            <img
              src={preview}
              alt={label}
              className="w-full h-full object-cover"
            />
            <button
              type="button"
              onClick={handleRemove}
              className="absolute top-2 right-2 p-1 rounded-full bg-black/50 text-white hover:bg-black/70 transition-colors"
            >
              <X className="w-4 h-4" />
            </button>
          </div>
        ) : (
          <button
            type="button"
            onClick={() => fileInputRef.current?.click()}
            className="w-full aspect-square rounded-xl border-2 border-dashed border-slate-300 dark:border-slate-600 flex flex-col items-center justify-center gap-2 text-slate-400 hover:border-primary-400 hover:text-primary-500 transition-colors"
          >
            <Icon className="w-8 h-8" />
            <span className="text-xs">{label}</span>
          </button>
        )}
      </div>
    );
  }

  return (
    <div className="w-full">
      <label className="form-label">{label}</label>
      <input
        ref={fileInputRef}
        type="file"
        accept="image/*"
        onChange={handleFileSelect}
        className="hidden"
      />
      {preview ? (
        <div className="relative glass-card overflow-hidden">
          <img
            src={preview}
            alt={label}
            className="w-full h-48 object-cover rounded-t-xl"
          />
          <div className="p-3 flex items-center justify-between bg-white/50 dark:bg-slate-800/50">
            <span className="text-sm text-slate-600 dark:text-slate-300">
              Image uploaded successfully
            </span>
            <button
              type="button"
              onClick={handleRemove}
              className="flex items-center gap-1 text-sm text-red-500 hover:text-red-600 transition-colors"
            >
              <X className="w-4 h-4" />
              Remove
            </button>
          </div>
        </div>
      ) : (
        <div
          className={`upload-zone ${isDragging ? 'border-primary-400 bg-primary-50/50 dark:bg-primary-900/10' : ''}`}
          onDragOver={handleDragOver}
          onDragLeave={handleDragLeave}
          onDrop={handleDrop}
          onClick={() => fileInputRef.current?.click()}
        >
          <div className="flex flex-col items-center gap-3">
            <div className="w-14 h-14 rounded-full bg-slate-100 dark:bg-slate-700 flex items-center justify-center">
              {isDragging ? (
                <Upload className="w-6 h-6 text-primary-500 animate-bounce" />
              ) : (
                <Icon className="w-6 h-6 text-slate-400" />
              )}
            </div>
            <div className="text-center">
              <p className="text-sm font-medium text-slate-700 dark:text-slate-300">
                Drop image here or click to upload
              </p>
              <p className="text-xs text-slate-400 mt-1">
                PNG, JPG up to 5MB
              </p>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

interface PhotoGalleryProps {
  photos: { id: string; type: string; url: string }[];
  onRemove?: (id: string) => void;
}

export function PhotoGallery({ photos, onRemove }: PhotoGalleryProps) {
  const typeLabels: Record<string, string> = {
    customer: 'Customer Photo',
    address_proof: 'Address Proof',
    id_proof: 'ID Proof',
    work_location: 'Work Location',
  };

  return (
    <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
      {photos.map((photo) => (
        <div key={photo.id} className="relative glass-card overflow-hidden group">
          <img
            src={photo.url}
            alt={typeLabels[photo.type] || photo.type}
            className="w-full aspect-square object-cover"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent opacity-0 group-hover:opacity-100 transition-opacity flex items-end">
            <div className="p-3 w-full">
              <p className="text-xs text-white font-medium">
                {typeLabels[photo.type] || photo.type}
              </p>
              {onRemove && (
                <button
                  type="button"
                  onClick={() => onRemove(photo.id)}
                  className="absolute top-2 right-2 p-1.5 rounded-full bg-red-500 text-white opacity-0 group-hover:opacity-100 hover:bg-red-600 transition-all"
                >
                  <X className="w-4 h-4" />
                </button>
              )}
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}
