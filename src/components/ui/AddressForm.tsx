import { useState } from 'react';
import { MapPin, ExternalLink } from 'lucide-react';
import { Input } from './Form';

interface AddressData {
  houseOrBuildingName?: string;
  landmark?: string;
  village?: string;
  taluk?: string;
  district?: string;
  state?: string;
  pinCode?: string;
  latitude?: number | null;
  longitude?: number | null;
  mapUrl?: string;
}

interface AddressFormProps {
  type: 'home' | 'current' | 'work';
  data?: AddressData;
  onChange: (data: Partial<AddressData>) => void;
  compact?: boolean;
}

function parseCoordsFromUrl(url: string): { lat: number; lng: number } | null {
  if (!url) return null;
  const atMatch = url.match(/@(-?\d+\.\d+),(-?\d+\.\d+)/);
  if (atMatch) return { lat: parseFloat(atMatch[1]), lng: parseFloat(atMatch[2]) };

  const qMatch = url.match(/[?&]q=(-?\d+\.\d+),(-?\d+\.\d+)/);
  if (qMatch) return { lat: parseFloat(qMatch[1]), lng: parseFloat(qMatch[2]) };

  const directMatch = url.match(/(-?\d+\.\d+)\s*,\s*(-?\d+\.\d+)/);
  if (directMatch) return { lat: parseFloat(directMatch[1]), lng: parseFloat(directMatch[2]) };

  return null;
}

export function AddressForm({ type, data, onChange, compact = false }: AddressFormProps) {
  const [mapCoords, setMapCoords] = useState<{ lat: number | null; lng: number | null }>({
    lat: data?.latitude != null ? Number(data.latitude) : null,
    lng: data?.longitude != null ? Number(data.longitude) : null,
  });

  const handleGetCurrentLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const { latitude, longitude } = position.coords;
          setMapCoords({ lat: latitude, lng: longitude });
          onChange({
            latitude,
            longitude,
            mapUrl: `https://maps.google.com/?q=${latitude},${longitude}`,
          });
        },
        (error) => {
          console.error('Error getting location:', error);
        }
      );
    }
  };

  const fieldLabels = {
    home: {
      building: 'House/Building Name',
      buildingPlaceholder: 'Enter house name',
    },
    current: {
      building: 'House/Building Name',
      buildingPlaceholder: 'Enter current house name',
    },
    work: {
      building: 'Office/Building Name',
      buildingPlaceholder: 'Enter office/building name',
    },
  };

  const labels = fieldLabels[type];

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-2 mb-4">
        <MapPin className="w-5 h-5 text-primary-500" />
        <h3 className="font-semibold text-slate-800 dark:text-white">
          {type === 'home' ? 'Permanent Address' : type === 'current' ? 'Current Address' : 'Work Address'}
        </h3>
      </div>

      <div className={`grid gap-4 ${compact ? 'grid-cols-1' : 'grid-cols-1 md:grid-cols-2'}`}>
        <Input
          label={labels.building}
          placeholder={labels.buildingPlaceholder}
          value={data?.houseOrBuildingName || ''}
          onChange={(e) => onChange({ houseOrBuildingName: e.target.value })}
        />
        <Input
          label="Landmark"
          placeholder="Near..."
          value={data?.landmark || ''}
          onChange={(e) => onChange({ landmark: e.target.value })}
        />
        <Input
          label="Village/Area"
          placeholder="Enter village or area"
          value={data?.village || ''}
          onChange={(e) => onChange({ village: e.target.value })}
        />
        <Input
          label="Taluk"
          placeholder="Enter taluk"
          value={data?.taluk || ''}
          onChange={(e) => onChange({ taluk: e.target.value })}
        />
        <Input
          label="District"
          placeholder="Enter district"
          value={data?.district || ''}
          onChange={(e) => onChange({ district: e.target.value })}
        />
        <Input
          label="State"
          placeholder="Enter state"
          value={data?.state || ''}
          onChange={(e) => onChange({ state: e.target.value })}
        />
        <Input
          label="PIN Code"
          placeholder="6-digit PIN code"
          maxLength={6}
          value={data?.pinCode || ''}
          onChange={(e) => onChange({ pinCode: e.target.value })}
        />
      </div>

      {/* Map Section */}
      <div className="mt-4">
        <label className="form-label mb-2 block">Location on Map / Custom Google Maps Link</label>
        <div className="mb-3">
          <Input
            label="Google Maps URL / Coordinates Query"
            placeholder="Paste Google Maps URL (e.g. https://maps.google.com/?q=...) or enter Lat, Lng"
            value={data?.mapUrl || ''}
            onChange={(e) => {
              const url = e.target.value;
              const coords = parseCoordsFromUrl(url);
              if (coords) {
                setMapCoords(coords);
                onChange({ mapUrl: url, latitude: coords.lat, longitude: coords.lng });
              } else {
                onChange({ mapUrl: url });
              }
            }}
          />
        </div>
        <div className="glass-card overflow-hidden">
          <div className="relative h-48 bg-slate-200 dark:bg-slate-700 rounded-t-xl overflow-hidden">
            <div className="absolute inset-0 flex items-center justify-center">
              <div className="text-center p-4">
                <MapPin className={`w-8 h-8 mx-auto mb-2 ${mapCoords.lat != null ? 'text-primary-500 animate-bounce' : 'text-slate-400'}`} />
                <p className="text-sm font-medium text-slate-600 dark:text-slate-300">
                  {mapCoords.lat != null && mapCoords.lng != null
                    ? `Lat: ${mapCoords.lat.toFixed(4)}, Lng: ${mapCoords.lng.toFixed(4)}`
                    : 'No Location Set'}
                </p>
                {mapCoords.lat == null && (
                  <p className="text-xs text-slate-400 mt-1">
                    Click "Use Current GPS Location" or paste a Google Maps link above to set coordinates.
                  </p>
                )}
              </div>
              <div className="absolute inset-0 bg-gradient-to-b from-transparent to-slate-100/50 dark:to-slate-800/50 pointer-events-none" />
            </div>
          </div>
          <div className="p-3 border-t border-slate-200/50 dark:border-slate-700/50 flex flex-wrap gap-2">
            <button
              type="button"
              onClick={handleGetCurrentLocation}
              className="flex items-center gap-2 px-3 py-2 text-sm rounded-lg bg-primary-50 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400 hover:bg-primary-100 dark:hover:bg-primary-900/50 transition-colors"
            >
              <MapPin className="w-4 h-4" />
              Use Current GPS Location
            </button>
            {data?.mapUrl && (
              <button
                type="button"
                onClick={() => window.open(data.mapUrl, '_blank')}
                className="flex items-center gap-2 px-3 py-2 text-sm rounded-lg bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-600 transition-colors"
              >
                <ExternalLink className="w-4 h-4" />
                Open in Maps
              </button>
            )}
          </div>
        </div>
        <div className="grid grid-cols-2 gap-4 mt-3">
          <Input
            label="Latitude"
            type="number"
            step="0.0001"
            value={mapCoords.lat ?? ''}
            onChange={(e) => {
              const lat = parseFloat(e.target.value);
              const newCoords = { ...mapCoords, lat: isNaN(lat) ? null : lat };
              setMapCoords(newCoords);
              if (newCoords.lat != null && newCoords.lng != null) {
                onChange({ latitude: newCoords.lat, longitude: newCoords.lng, mapUrl: `https://maps.google.com/?q=${newCoords.lat},${newCoords.lng}` });
              }
            }}
          />
          <Input
            label="Longitude"
            type="number"
            step="0.0001"
            value={mapCoords.lng ?? ''}
            onChange={(e) => {
              const lng = parseFloat(e.target.value);
              const newCoords = { ...mapCoords, lng: isNaN(lng) ? null : lng };
              setMapCoords(newCoords);
              if (newCoords.lat != null && newCoords.lng != null) {
                onChange({ latitude: newCoords.lat, longitude: newCoords.lng, mapUrl: `https://maps.google.com/?q=${newCoords.lat},${newCoords.lng}` });
              }
            }}
          />
        </div>
      </div>
    </div>
  );
}
