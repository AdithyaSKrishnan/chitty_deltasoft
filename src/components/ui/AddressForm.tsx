import { useState, useEffect } from 'react';
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
  type: 'home' | 'work';
  data?: AddressData;
  onChange: (data: Partial<AddressData>) => void;
  compact?: boolean;
}

export function AddressForm({ type, data, onChange, compact = false }: AddressFormProps) {
  const [mapCoords, setMapCoords] = useState({
    lat: data?.latitude || 17.385,
    lng: data?.longitude || 78.4867,
  });

  useEffect(() => {
    onChange({
      latitude: mapCoords.lat,
      longitude: mapCoords.lng,
      mapUrl: `https://maps.google.com/?q=${mapCoords.lat},${mapCoords.lng}`,
    });
  }, [mapCoords]);

  const handleGetCurrentLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const { latitude, longitude } = position.coords;
          setMapCoords({ lat: latitude, lng: longitude });
        },
        (error) => {
          console.error('Error getting location:', error);
        }
      );
    }
  };

  const fieldLabels = {
    home: {
      building: 'House Name',
      buildingPlaceholder: 'Enter house name',
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
          {type === 'home' ? 'Home Address' : 'Work Address'}
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
        <label className="form-label">Location on Map</label>
        <div className="glass-card overflow-hidden">
          <div className="relative h-48 bg-slate-200 dark:bg-slate-700 rounded-t-xl overflow-hidden">
            <div className="absolute inset-0 flex items-center justify-center">
              <div className="text-center">
                <MapPin className="w-8 h-8 text-primary-500 mx-auto mb-2 animate-bounce" />
                <p className="text-sm text-slate-600 dark:text-slate-300">
                  Lat: {mapCoords.lat.toFixed(4)}, Lng: {mapCoords.lng.toFixed(4)}
                </p>
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
              Use Current Location
            </button>
            <button
              type="button"
              onClick={() =>
                window.open(
                  `https://maps.google.com/?q=${mapCoords.lat},${mapCoords.lng}`,
                  '_blank'
                )
              }
              className="flex items-center gap-2 px-3 py-2 text-sm rounded-lg bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-600 transition-colors"
            >
              <ExternalLink className="w-4 h-4" />
              Open in Maps
            </button>
          </div>
        </div>
        <div className="grid grid-cols-2 gap-4 mt-3">
          <Input
            label="Latitude"
            type="number"
            step="0.0001"
            value={mapCoords.lat}
            onChange={(e) =>
              setMapCoords({ ...mapCoords, lat: parseFloat(e.target.value) || 0 })
            }
          />
          <Input
            label="Longitude"
            type="number"
            step="0.0001"
            value={mapCoords.lng}
            onChange={(e) =>
              setMapCoords({ ...mapCoords, lng: parseFloat(e.target.value) || 0 })
            }
          />
        </div>
      </div>
    </div>
  );
}
