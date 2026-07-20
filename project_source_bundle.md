
### File: bundle.py
```py
import os

# Folders you absolutely want to ignore
IGNORE_DIRS = {
    'node_modules', '.git', '.dart_tool', 'build', 
    'ios', 'android', 'windows', 'macos', 'linux', 
    '.idea', '.vscode', 'assets', 'outputs'
}

# Only pull the actual code files you wrote (feel free to add or remove extensions)
VALID_EXTENSIONS = {'.dart', '.py', '.js', '.ts', '.jsx', '.tsx', '.json', '.yaml'}

output_file = "project_source_bundle.md"

with open(output_file, "w", encoding="utf-8") as outfile:
    for root, dirs, files in os.walk("."):
        # Modifies dirs in-place to skip ignored folders
        dirs[:] = [d for d in dirs if d not in IGNORE_DIRS]
        
        for file in files:
            ext = os.path.splitext(file)[1]
            if ext in VALID_EXTENSIONS:
                relative_path = os.path.relpath(os.path.join(root, file), ".")
                
                # Write file header
                outfile.write(f"\n### File: {relative_path}\n")
                # Wrap code in markdown block using the extension name as language hint
                outfile.write(f"```{ext[1:]}\n")
                
                try:
                    with open(os.path.join(root, file), "r", encoding="utf-8") as infile:
                        outfile.write(infile.read())
                except Exception as e:
                    outfile.write(f"// Error reading file: {str(e)}\n")
                
                outfile.write("\n```\n")
                outfile.write("\n" + "-"*40 + "\n")

print(f"Success! Core code bundled into {output_file}")
```

----------------------------------------

### File: eslint.config.js
```js
import js from '@eslint/js';
import globals from 'globals';
import reactHooks from 'eslint-plugin-react-hooks';
import reactRefresh from 'eslint-plugin-react-refresh';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  { ignores: ['dist'] },
  {
    extends: [js.configs.recommended, ...tseslint.configs.recommended],
    files: ['**/*.{ts,tsx}'],
    languageOptions: {
      ecmaVersion: 2020,
      globals: globals.browser,
    },
    plugins: {
      'react-hooks': reactHooks,
      'react-refresh': reactRefresh,
    },
    rules: {
      ...reactHooks.configs.recommended.rules,
      'react-refresh/only-export-components': [
        'warn',
        { allowConstantExport: true },
      ],
    },
  }
);

```

----------------------------------------

### File: package-lock.json
```json
{
  "name": "vite-react-typescript-starter",
  "version": "0.0.0",
  "lockfileVersion": 3,
  "requires": true,
  "packages": {
    "": {
      "name": "vite-react-typescript-starter",
      "version": "0.0.0",
      "dependencies": {
        "@supabase/supabase-js": "^2.57.4",
        "@types/leaflet": "^1.9.21",
        "axios": "^1.17.0",
        "leaflet": "^1.9.4",
        "lucide-react": "^0.344.0",
        "react": "^18.3.1",
        "react-dom": "^18.3.1",
        "react-leaflet": "^5.0.0",
        "react-router-dom": "^7.17.0"
      },
      "devDependencies": {
        "@eslint/js": "^9.9.1",
        "@types/react": "^18.3.5",
        "@types/react-dom": "^18.3.0",
        "@vitejs/plugin-react": "^4.3.1",
        "autoprefixer": "^10.4.18",
        "eslint": "^9.9.1",
        "eslint-plugin-react-hooks": "^5.1.0-rc.0",
        "eslint-plugin-react-refresh": "^0.4.11",
        "globals": "^15.9.0",
        "postcss": "^8.4.35",
        "tailwindcss": "^3.4.1",
        "typescript": "^5.5.3",
        "typescript-eslint": "^8.3.0",
        "vite": "^5.4.2"
      }
    },
    "node_modules/@alloc/quick-lru": {
      "version": "5.2.0",
      "resolved": "https://registry.npmjs.org/@alloc/quick-lru/-/quick-lru-5.2.0.tgz",
      "integrity": "sha512-UrcABB+4bUrFABwbluTIBErXwvbsU/V7TZWfmbgJfbkwiBuziS9gxdODUyuiecfdGQ85jglMW6juS3+z5TsKLw==",
      "dev": true,
      "engines": {
        "node": ">=10"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/@ampproject/remapping": {
      "version": "2.3.0",
      "resolved": "https://registry.npmjs.org/@ampproject/remapping/-/remapping-2.3.0.tgz",
      "integrity": "sha512-30iZtAPgz+LTIYoeivqYo853f02jBYSd5uGnGpkFV0M3xOt9aN73erkgYAmZU43x4VfqcnLxW9Kpg3R5LC4YYw==",
      "dev": true,
      "dependencies": {
        "@jridgewell/gen-mapping": "^0.3.5",
        "@jridgewell/trace-mapping": "^0.3.24"
      },
      "engines": {
        "node": ">=6.0.0"
      }
    },
    "node_modules/@babel/code-frame": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.25.7.tgz",
      "integrity": "sha512-0xZJFNE5XMpENsgfHYTw8FbX4kv53mFLn2i3XPoq69LyhYSCBJtitaHx9QnsVTrsogI4Z3+HtEfZ2/GFPOtf5g==",
      "dev": true,
      "dependencies": {
        "@babel/highlight": "^7.25.7",
        "picocolors": "^1.0.0"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/compat-data": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/compat-data/-/compat-data-7.25.7.tgz",
      "integrity": "sha512-9ickoLz+hcXCeh7jrcin+/SLWm+GkxE2kTvoYyp38p4WkdFXfQJxDFGWp/YHjiKLPx06z2A7W8XKuqbReXDzsw==",
      "dev": true,
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/core": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/core/-/core-7.25.7.tgz",
      "integrity": "sha512-yJ474Zv3cwiSOO9nXJuqzvwEeM+chDuQ8GJirw+pZ91sCGCyOZ3dJkVE09fTV0VEVzXyLWhh3G/AolYTPX7Mow==",
      "dev": true,
      "dependencies": {
        "@ampproject/remapping": "^2.2.0",
        "@babel/code-frame": "^7.25.7",
        "@babel/generator": "^7.25.7",
        "@babel/helper-compilation-targets": "^7.25.7",
        "@babel/helper-module-transforms": "^7.25.7",
        "@babel/helpers": "^7.25.7",
        "@babel/parser": "^7.25.7",
        "@babel/template": "^7.25.7",
        "@babel/traverse": "^7.25.7",
        "@babel/types": "^7.25.7",
        "convert-source-map": "^2.0.0",
        "debug": "^4.1.0",
        "gensync": "^1.0.0-beta.2",
        "json5": "^2.2.3",
        "semver": "^6.3.1"
      },
      "engines": {
        "node": ">=6.9.0"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/babel"
      }
    },
    "node_modules/@babel/generator": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/generator/-/generator-7.25.7.tgz",
      "integrity": "sha512-5Dqpl5fyV9pIAD62yK9P7fcA768uVPUyrQmqpqstHWgMma4feF1x/oFysBCVZLY5wJ2GkMUCdsNDnGZrPoR6rA==",
      "dev": true,
      "dependencies": {
        "@babel/types": "^7.25.7",
        "@jridgewell/gen-mapping": "^0.3.5",
        "@jridgewell/trace-mapping": "^0.3.25",
        "jsesc": "^3.0.2"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helper-compilation-targets": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.25.7.tgz",
      "integrity": "sha512-DniTEax0sv6isaw6qSQSfV4gVRNtw2rte8HHM45t9ZR0xILaufBRNkpMifCRiAPyvL4ACD6v0gfCwCmtOQaV4A==",
      "dev": true,
      "dependencies": {
        "@babel/compat-data": "^7.25.7",
        "@babel/helper-validator-option": "^7.25.7",
        "browserslist": "^4.24.0",
        "lru-cache": "^5.1.1",
        "semver": "^6.3.1"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helper-module-imports": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.25.7.tgz",
      "integrity": "sha512-o0xCgpNmRohmnoWKQ0Ij8IdddjyBFE4T2kagL/x6M3+4zUgc+4qTOUBoNe4XxDskt1HPKO007ZPiMgLDq2s7Kw==",
      "dev": true,
      "dependencies": {
        "@babel/traverse": "^7.25.7",
        "@babel/types": "^7.25.7"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helper-module-transforms": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.25.7.tgz",
      "integrity": "sha512-k/6f8dKG3yDz/qCwSM+RKovjMix563SLxQFo0UhRNo239SP6n9u5/eLtKD6EAjwta2JHJ49CsD8pms2HdNiMMQ==",
      "dev": true,
      "dependencies": {
        "@babel/helper-module-imports": "^7.25.7",
        "@babel/helper-simple-access": "^7.25.7",
        "@babel/helper-validator-identifier": "^7.25.7",
        "@babel/traverse": "^7.25.7"
      },
      "engines": {
        "node": ">=6.9.0"
      },
      "peerDependencies": {
        "@babel/core": "^7.0.0"
      }
    },
    "node_modules/@babel/helper-plugin-utils": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.25.7.tgz",
      "integrity": "sha512-eaPZai0PiqCi09pPs3pAFfl/zYgGaE6IdXtYvmf0qlcDTd3WCtO7JWCcRd64e0EQrcYgiHibEZnOGsSY4QSgaw==",
      "dev": true,
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helper-simple-access": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/helper-simple-access/-/helper-simple-access-7.25.7.tgz",
      "integrity": "sha512-FPGAkJmyoChQeM+ruBGIDyrT2tKfZJO8NcxdC+CWNJi7N8/rZpSxK7yvBJ5O/nF1gfu5KzN7VKG3YVSLFfRSxQ==",
      "dev": true,
      "dependencies": {
        "@babel/traverse": "^7.25.7",
        "@babel/types": "^7.25.7"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helper-string-parser": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.25.7.tgz",
      "integrity": "sha512-CbkjYdsJNHFk8uqpEkpCvRs3YRp9tY6FmFY7wLMSYuGYkrdUi7r2lc4/wqsvlHoMznX3WJ9IP8giGPq68T/Y6g==",
      "dev": true,
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helper-validator-identifier": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.25.7.tgz",
      "integrity": "sha512-AM6TzwYqGChO45oiuPqwL2t20/HdMC1rTPAesnBCgPCSF1x3oN9MVUwQV2iyz4xqWrctwK5RNC8LV22kaQCNYg==",
      "dev": true,
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helper-validator-option": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/helper-validator-option/-/helper-validator-option-7.25.7.tgz",
      "integrity": "sha512-ytbPLsm+GjArDYXJ8Ydr1c/KJuutjF2besPNbIZnZ6MKUxi/uTA22t2ymmA4WFjZFpjiAMO0xuuJPqK2nvDVfQ==",
      "dev": true,
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helpers": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/helpers/-/helpers-7.25.7.tgz",
      "integrity": "sha512-Sv6pASx7Esm38KQpF/U/OXLwPPrdGHNKoeblRxgZRLXnAtnkEe4ptJPDtAZM7fBLadbc1Q07kQpSiGQ0Jg6tRA==",
      "dev": true,
      "dependencies": {
        "@babel/template": "^7.25.7",
        "@babel/types": "^7.25.7"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/highlight": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/highlight/-/highlight-7.25.7.tgz",
      "integrity": "sha512-iYyACpW3iW8Fw+ZybQK+drQre+ns/tKpXbNESfrhNnPLIklLbXr7MYJ6gPEd0iETGLOK+SxMjVvKb/ffmk+FEw==",
      "dev": true,
      "dependencies": {
        "@babel/helper-validator-identifier": "^7.25.7",
        "chalk": "^2.4.2",
        "js-tokens": "^4.0.0",
        "picocolors": "^1.0.0"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/parser": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/parser/-/parser-7.25.7.tgz",
      "integrity": "sha512-aZn7ETtQsjjGG5HruveUK06cU3Hljuhd9Iojm4M8WWv3wLE6OkE5PWbDUkItmMgegmccaITudyuW5RPYrYlgWw==",
      "dev": true,
      "dependencies": {
        "@babel/types": "^7.25.7"
      },
      "bin": {
        "parser": "bin/babel-parser.js"
      },
      "engines": {
        "node": ">=6.0.0"
      }
    },
    "node_modules/@babel/plugin-transform-react-jsx-self": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/plugin-transform-react-jsx-self/-/plugin-transform-react-jsx-self-7.25.7.tgz",
      "integrity": "sha512-JD9MUnLbPL0WdVK8AWC7F7tTG2OS6u/AKKnsK+NdRhUiVdnzyR1S3kKQCaRLOiaULvUiqK6Z4JQE635VgtCFeg==",
      "dev": true,
      "dependencies": {
        "@babel/helper-plugin-utils": "^7.25.7"
      },
      "engines": {
        "node": ">=6.9.0"
      },
      "peerDependencies": {
        "@babel/core": "^7.0.0-0"
      }
    },
    "node_modules/@babel/plugin-transform-react-jsx-source": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/plugin-transform-react-jsx-source/-/plugin-transform-react-jsx-source-7.25.7.tgz",
      "integrity": "sha512-S/JXG/KrbIY06iyJPKfxr0qRxnhNOdkNXYBl/rmwgDd72cQLH9tEGkDm/yJPGvcSIUoikzfjMios9i+xT/uv9w==",
      "dev": true,
      "dependencies": {
        "@babel/helper-plugin-utils": "^7.25.7"
      },
      "engines": {
        "node": ">=6.9.0"
      },
      "peerDependencies": {
        "@babel/core": "^7.0.0-0"
      }
    },
    "node_modules/@babel/template": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/template/-/template-7.25.7.tgz",
      "integrity": "sha512-wRwtAgI3bAS+JGU2upWNL9lSlDcRCqD05BZ1n3X2ONLH1WilFP6O1otQjeMK/1g0pvYcXC7b/qVUB1keofjtZA==",
      "dev": true,
      "dependencies": {
        "@babel/code-frame": "^7.25.7",
        "@babel/parser": "^7.25.7",
        "@babel/types": "^7.25.7"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/traverse": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/traverse/-/traverse-7.25.7.tgz",
      "integrity": "sha512-jatJPT1Zjqvh/1FyJs6qAHL+Dzb7sTb+xr7Q+gM1b+1oBsMsQQ4FkVKb6dFlJvLlVssqkRzV05Jzervt9yhnzg==",
      "dev": true,
      "dependencies": {
        "@babel/code-frame": "^7.25.7",
        "@babel/generator": "^7.25.7",
        "@babel/parser": "^7.25.7",
        "@babel/template": "^7.25.7",
        "@babel/types": "^7.25.7",
        "debug": "^4.3.1",
        "globals": "^11.1.0"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/traverse/node_modules/globals": {
      "version": "11.12.0",
      "resolved": "https://registry.npmjs.org/globals/-/globals-11.12.0.tgz",
      "integrity": "sha512-WOBp/EEGUiIsJSp7wcv/y6MO+lV9UoncWqxuFfm8eBwzWNgyfBd6Gz+IeKQ9jCmyhoH99g15M3T+QaVHFjizVA==",
      "dev": true,
      "engines": {
        "node": ">=4"
      }
    },
    "node_modules/@babel/types": {
      "version": "7.25.7",
      "resolved": "https://registry.npmjs.org/@babel/types/-/types-7.25.7.tgz",
      "integrity": "sha512-vwIVdXG+j+FOpkwqHRcBgHLYNL7XMkufrlaFvL9o6Ai9sJn9+PdyIL5qa0XzTZw084c+u9LOls53eoZWP/W5WQ==",
      "dev": true,
      "dependencies": {
        "@babel/helper-string-parser": "^7.25.7",
        "@babel/helper-validator-identifier": "^7.25.7",
        "to-fast-properties": "^2.0.0"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@esbuild/aix-ppc64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/aix-ppc64/-/aix-ppc64-0.21.5.tgz",
      "integrity": "sha512-1SDgH6ZSPTlggy1yI6+Dbkiz8xzpHJEVAlF/AM1tHPLsf5STom9rwtjE4hKAF20FfXXNTFqEYXyJNWh1GiZedQ==",
      "cpu": [
        "ppc64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "aix"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/android-arm": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.21.5.tgz",
      "integrity": "sha512-vCPvzSjpPHEi1siZdlvAlsPxXl7WbOVUBBAowWug4rJHb68Ox8KualB+1ocNvT5fjv6wpkX6o/iEpbDrf68zcg==",
      "cpu": [
        "arm"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "android"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/android-arm64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.21.5.tgz",
      "integrity": "sha512-c0uX9VAUBQ7dTDCjq+wdyGLowMdtR/GoC2U5IYk/7D1H1JYC0qseD7+11iMP2mRLN9RcCMRcjC4YMclCzGwS/A==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "android"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/android-x64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.21.5.tgz",
      "integrity": "sha512-D7aPRUUNHRBwHxzxRvp856rjUHRFW1SdQATKXH2hqA0kAZb1hKmi02OpYRacl0TxIGz/ZmXWlbZgjwWYaCakTA==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "android"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/darwin-arm64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.21.5.tgz",
      "integrity": "sha512-DwqXqZyuk5AiWWf3UfLiRDJ5EDd49zg6O9wclZ7kUMv2WRFr4HKjXp/5t8JZ11QbQfUS6/cRCKGwYhtNAY88kQ==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "darwin"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/darwin-x64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.21.5.tgz",
      "integrity": "sha512-se/JjF8NlmKVG4kNIuyWMV/22ZaerB+qaSi5MdrXtd6R08kvs2qCN4C09miupktDitvh8jRFflwGFBQcxZRjbw==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "darwin"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/freebsd-arm64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.21.5.tgz",
      "integrity": "sha512-5JcRxxRDUJLX8JXp/wcBCy3pENnCgBR9bN6JsY4OmhfUtIHe3ZW0mawA7+RDAcMLrMIZaf03NlQiX9DGyB8h4g==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "freebsd"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/freebsd-x64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.21.5.tgz",
      "integrity": "sha512-J95kNBj1zkbMXtHVH29bBriQygMXqoVQOQYA+ISs0/2l3T9/kj42ow2mpqerRBxDJnmkUDCaQT/dfNXWX/ZZCQ==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "freebsd"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-arm": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.21.5.tgz",
      "integrity": "sha512-bPb5AHZtbeNGjCKVZ9UGqGwo8EUu4cLq68E95A53KlxAPRmUyYv2D6F0uUI65XisGOL1hBP5mTronbgo+0bFcA==",
      "cpu": [
        "arm"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-arm64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.21.5.tgz",
      "integrity": "sha512-ibKvmyYzKsBeX8d8I7MH/TMfWDXBF3db4qM6sy+7re0YXya+K1cem3on9XgdT2EQGMu4hQyZhan7TeQ8XkGp4Q==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-ia32": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.21.5.tgz",
      "integrity": "sha512-YvjXDqLRqPDl2dvRODYmmhz4rPeVKYvppfGYKSNGdyZkA01046pLWyRKKI3ax8fbJoK5QbxblURkwK/MWY18Tg==",
      "cpu": [
        "ia32"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-loong64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.21.5.tgz",
      "integrity": "sha512-uHf1BmMG8qEvzdrzAqg2SIG/02+4/DHB6a9Kbya0XDvwDEKCoC8ZRWI5JJvNdUjtciBGFQ5PuBlpEOXQj+JQSg==",
      "cpu": [
        "loong64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-mips64el": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.21.5.tgz",
      "integrity": "sha512-IajOmO+KJK23bj52dFSNCMsz1QP1DqM6cwLUv3W1QwyxkyIWecfafnI555fvSGqEKwjMXVLokcV5ygHW5b3Jbg==",
      "cpu": [
        "mips64el"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-ppc64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.21.5.tgz",
      "integrity": "sha512-1hHV/Z4OEfMwpLO8rp7CvlhBDnjsC3CttJXIhBi+5Aj5r+MBvy4egg7wCbe//hSsT+RvDAG7s81tAvpL2XAE4w==",
      "cpu": [
        "ppc64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-riscv64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.21.5.tgz",
      "integrity": "sha512-2HdXDMd9GMgTGrPWnJzP2ALSokE/0O5HhTUvWIbD3YdjME8JwvSCnNGBnTThKGEB91OZhzrJ4qIIxk/SBmyDDA==",
      "cpu": [
        "riscv64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-s390x": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.21.5.tgz",
      "integrity": "sha512-zus5sxzqBJD3eXxwvjN1yQkRepANgxE9lgOW2qLnmr8ikMTphkjgXu1HR01K4FJg8h1kEEDAqDcZQtbrRnB41A==",
      "cpu": [
        "s390x"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-x64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.21.5.tgz",
      "integrity": "sha512-1rYdTpyv03iycF1+BhzrzQJCdOuAOtaqHTWJZCWvijKD2N5Xu0TtVC8/+1faWqcP9iBCWOmjmhoH94dH82BxPQ==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/netbsd-x64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.21.5.tgz",
      "integrity": "sha512-Woi2MXzXjMULccIwMnLciyZH4nCIMpWQAs049KEeMvOcNADVxo0UBIQPfSmxB3CWKedngg7sWZdLvLczpe0tLg==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "netbsd"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/openbsd-x64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.21.5.tgz",
      "integrity": "sha512-HLNNw99xsvx12lFBUwoT8EVCsSvRNDVxNpjZ7bPn947b8gJPzeHWyNVhFsaerc0n3TsbOINvRP2byTZ5LKezow==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "openbsd"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/sunos-x64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.21.5.tgz",
      "integrity": "sha512-6+gjmFpfy0BHU5Tpptkuh8+uw3mnrvgs+dSPQXQOv3ekbordwnzTVEb4qnIvQcYXq6gzkyTnoZ9dZG+D4garKg==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "sunos"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/win32-arm64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.21.5.tgz",
      "integrity": "sha512-Z0gOTd75VvXqyq7nsl93zwahcTROgqvuAcYDUr+vOv8uHhNSKROyU961kgtCD1e95IqPKSQKH7tBTslnS3tA8A==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "win32"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/win32-ia32": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.21.5.tgz",
      "integrity": "sha512-SWXFF1CL2RVNMaVs+BBClwtfZSvDgtL//G/smwAc5oVK/UPu2Gu9tIaRgFmYFFKrmg3SyAjSrElf0TiJ1v8fYA==",
      "cpu": [
        "ia32"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "win32"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/win32-x64": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.21.5.tgz",
      "integrity": "sha512-tQd/1efJuzPC6rCFwEvLtci/xNFcTZknmXs98FYDfGE4wP9ClFV98nyKrzJKVPMhdDnjzLhdUyMX4PsQAPjwIw==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "win32"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@eslint-community/eslint-utils": {
      "version": "4.4.0",
      "resolved": "https://registry.npmjs.org/@eslint-community/eslint-utils/-/eslint-utils-4.4.0.tgz",
      "integrity": "sha512-1/sA4dwrzBAyeUoQ6oxahHKmrZvsnLCg4RfxW3ZFGGmQkSNQPFNLV9CUEFQP1x9EYXHTo5p6xdhZM1Ne9p/AfA==",
      "dev": true,
      "dependencies": {
        "eslint-visitor-keys": "^3.3.0"
      },
      "engines": {
        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
      },
      "peerDependencies": {
        "eslint": "^6.0.0 || ^7.0.0 || >=8.0.0"
      }
    },
    "node_modules/@eslint-community/eslint-utils/node_modules/eslint-visitor-keys": {
      "version": "3.4.3",
      "resolved": "https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-3.4.3.tgz",
      "integrity": "sha512-wpc+LXeiyiisxPlEkUzU6svyS1frIO3Mgxj1fdy7Pm8Ygzguax2N3Fa/D/ag1WqbOprdI+uY6wMUl8/a2G+iag==",
      "dev": true,
      "engines": {
        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
      },
      "funding": {
        "url": "https://opencollective.com/eslint"
      }
    },
    "node_modules/@eslint-community/regexpp": {
      "version": "4.11.1",
      "resolved": "https://registry.npmjs.org/@eslint-community/regexpp/-/regexpp-4.11.1.tgz",
      "integrity": "sha512-m4DVN9ZqskZoLU5GlWZadwDnYo3vAEydiUayB9widCl9ffWx2IvPnp6n3on5rJmziJSw9Bv+Z3ChDVdMwXCY8Q==",
      "dev": true,
      "engines": {
        "node": "^12.0.0 || ^14.0.0 || >=16.0.0"
      }
    },
    "node_modules/@eslint/config-array": {
      "version": "0.18.0",
      "resolved": "https://registry.npmjs.org/@eslint/config-array/-/config-array-0.18.0.tgz",
      "integrity": "sha512-fTxvnS1sRMu3+JjXwJG0j/i4RT9u4qJ+lqS/yCGap4lH4zZGzQ7tu+xZqQmcMZq5OBZDL4QRxQzRjkWcGt8IVw==",
      "dev": true,
      "dependencies": {
        "@eslint/object-schema": "^2.1.4",
        "debug": "^4.3.1",
        "minimatch": "^3.1.2"
      },
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      }
    },
    "node_modules/@eslint/core": {
      "version": "0.6.0",
      "resolved": "https://registry.npmjs.org/@eslint/core/-/core-0.6.0.tgz",
      "integrity": "sha512-8I2Q8ykA4J0x0o7cg67FPVnehcqWTBehu/lmY+bolPFHGjh49YzGBMXTvpqVgEbBdvNCSxj6iFgiIyHzf03lzg==",
      "dev": true,
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      }
    },
    "node_modules/@eslint/eslintrc": {
      "version": "3.1.0",
      "resolved": "https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-3.1.0.tgz",
      "integrity": "sha512-4Bfj15dVJdoy3RfZmmo86RK1Fwzn6SstsvK9JS+BaVKqC6QQQQyXekNaC+g+LKNgkQ+2VhGAzm6hO40AhMR3zQ==",
      "dev": true,
      "dependencies": {
        "ajv": "^6.12.4",
        "debug": "^4.3.2",
        "espree": "^10.0.1",
        "globals": "^14.0.0",
        "ignore": "^5.2.0",
        "import-fresh": "^3.2.1",
        "js-yaml": "^4.1.0",
        "minimatch": "^3.1.2",
        "strip-json-comments": "^3.1.1"
      },
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      },
      "funding": {
        "url": "https://opencollective.com/eslint"
      }
    },
    "node_modules/@eslint/eslintrc/node_modules/globals": {
      "version": "14.0.0",
      "resolved": "https://registry.npmjs.org/globals/-/globals-14.0.0.tgz",
      "integrity": "sha512-oahGvuMGQlPw/ivIYBjVSrWAfWLBeku5tpPE2fOPLi+WHffIWbuh2tCjhyQhTBPMf5E9jDEH4FOmTYgYwbKwtQ==",
      "dev": true,
      "engines": {
        "node": ">=18"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/@eslint/js": {
      "version": "9.12.0",
      "resolved": "https://registry.npmjs.org/@eslint/js/-/js-9.12.0.tgz",
      "integrity": "sha512-eohesHH8WFRUprDNyEREgqP6beG6htMeUYeCpkEgBCieCMme5r9zFWjzAJp//9S+Kub4rqE+jXe9Cp1a7IYIIA==",
      "dev": true,
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      }
    },
    "node_modules/@eslint/object-schema": {
      "version": "2.1.4",
      "resolved": "https://registry.npmjs.org/@eslint/object-schema/-/object-schema-2.1.4.tgz",
      "integrity": "sha512-BsWiH1yFGjXXS2yvrf5LyuoSIIbPrGUWob917o+BTKuZ7qJdxX8aJLRxs1fS9n6r7vESrq1OUqb68dANcFXuQQ==",
      "dev": true,
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      }
    },
    "node_modules/@eslint/plugin-kit": {
      "version": "0.2.0",
      "resolved": "https://registry.npmjs.org/@eslint/plugin-kit/-/plugin-kit-0.2.0.tgz",
      "integrity": "sha512-vH9PiIMMwvhCx31Af3HiGzsVNULDbyVkHXwlemn/B0TFj/00ho3y55efXrUZTfQipxoHC5u4xq6zblww1zm1Ig==",
      "dev": true,
      "dependencies": {
        "levn": "^0.4.1"
      },
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      }
    },
    "node_modules/@humanfs/core": {
      "version": "0.19.0",
      "resolved": "https://registry.npmjs.org/@humanfs/core/-/core-0.19.0.tgz",
      "integrity": "sha512-2cbWIHbZVEweE853g8jymffCA+NCMiuqeECeBBLm8dg2oFdjuGJhgN4UAbI+6v0CKbbhvtXA4qV8YR5Ji86nmw==",
      "dev": true,
      "engines": {
        "node": ">=18.18.0"
      }
    },
    "node_modules/@humanfs/node": {
      "version": "0.16.5",
      "resolved": "https://registry.npmjs.org/@humanfs/node/-/node-0.16.5.tgz",
      "integrity": "sha512-KSPA4umqSG4LHYRodq31VDwKAvaTF4xmVlzM8Aeh4PlU1JQ3IG0wiA8C25d3RQ9nJyM3mBHyI53K06VVL/oFFg==",
      "dev": true,
      "dependencies": {
        "@humanfs/core": "^0.19.0",
        "@humanwhocodes/retry": "^0.3.0"
      },
      "engines": {
        "node": ">=18.18.0"
      }
    },
    "node_modules/@humanwhocodes/module-importer": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz",
      "integrity": "sha512-bxveV4V8v5Yb4ncFTT3rPSgZBOpCkjfK0y4oVVVJwIuDVBRMDXrPyXRL988i5ap9m9bnyEEjWfm5WkBmtffLfA==",
      "dev": true,
      "engines": {
        "node": ">=12.22"
      },
      "funding": {
        "type": "github",
        "url": "https://github.com/sponsors/nzakas"
      }
    },
    "node_modules/@humanwhocodes/retry": {
      "version": "0.3.1",
      "resolved": "https://registry.npmjs.org/@humanwhocodes/retry/-/retry-0.3.1.tgz",
      "integrity": "sha512-JBxkERygn7Bv/GbN5Rv8Ul6LVknS+5Bp6RgDC/O8gEBU/yeH5Ui5C/OlWrTb6qct7LjjfT6Re2NxB0ln0yYybA==",
      "dev": true,
      "engines": {
        "node": ">=18.18"
      },
      "funding": {
        "type": "github",
        "url": "https://github.com/sponsors/nzakas"
      }
    },
    "node_modules/@isaacs/cliui": {
      "version": "8.0.2",
      "resolved": "https://registry.npmjs.org/@isaacs/cliui/-/cliui-8.0.2.tgz",
      "integrity": "sha512-O8jcjabXaleOG9DQ0+ARXWZBTfnP4WNAqzuiJK7ll44AmxGKv/J2M4TPjxjY3znBCfvBXFzucm1twdyFybFqEA==",
      "dev": true,
      "dependencies": {
        "string-width": "^5.1.2",
        "string-width-cjs": "npm:string-width@^4.2.0",
        "strip-ansi": "^7.0.1",
        "strip-ansi-cjs": "npm:strip-ansi@^6.0.1",
        "wrap-ansi": "^8.1.0",
        "wrap-ansi-cjs": "npm:wrap-ansi@^7.0.0"
      },
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@jridgewell/gen-mapping": {
      "version": "0.3.5",
      "resolved": "https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.5.tgz",
      "integrity": "sha512-IzL8ZoEDIBRWEzlCcRhOaCupYyN5gdIK+Q6fbFdPDg6HqX6jpkItn7DFIpW9LQzXG6Df9sA7+OKnq0qlz/GaQg==",
      "dev": true,
      "dependencies": {
        "@jridgewell/set-array": "^1.2.1",
        "@jridgewell/sourcemap-codec": "^1.4.10",
        "@jridgewell/trace-mapping": "^0.3.24"
      },
      "engines": {
        "node": ">=6.0.0"
      }
    },
    "node_modules/@jridgewell/resolve-uri": {
      "version": "3.1.2",
      "resolved": "https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz",
      "integrity": "sha512-bRISgCIjP20/tbWSPWMEi54QVPRZExkuD9lJL+UIxUKtwVJA8wW1Trb1jMs1RFXo1CBTNZ/5hpC9QvmKWdopKw==",
      "dev": true,
      "engines": {
        "node": ">=6.0.0"
      }
    },
    "node_modules/@jridgewell/set-array": {
      "version": "1.2.1",
      "resolved": "https://registry.npmjs.org/@jridgewell/set-array/-/set-array-1.2.1.tgz",
      "integrity": "sha512-R8gLRTZeyp03ymzP/6Lil/28tGeGEzhx1q2k703KGWRAI1VdvPIXdG70VJc2pAMw3NA6JKL5hhFu1sJX0Mnn/A==",
      "dev": true,
      "engines": {
        "node": ">=6.0.0"
      }
    },
    "node_modules/@jridgewell/sourcemap-codec": {
      "version": "1.5.0",
      "resolved": "https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.0.tgz",
      "integrity": "sha512-gv3ZRaISU3fjPAgNsriBRqGWQL6quFx04YMPW/zD8XMLsU32mhCCbfbO6KZFLjvYpCZ8zyDEgqsgf+PwPaM7GQ==",
      "dev": true
    },
    "node_modules/@jridgewell/trace-mapping": {
      "version": "0.3.25",
      "resolved": "https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.25.tgz",
      "integrity": "sha512-vNk6aEwybGtawWmy/PzwnGDOjCkLWSD2wqvjGGAgOAwCGWySYXfYoxt00IJkTF+8Lb57DwOb3Aa0o9CApepiYQ==",
      "dev": true,
      "dependencies": {
        "@jridgewell/resolve-uri": "^3.1.0",
        "@jridgewell/sourcemap-codec": "^1.4.14"
      }
    },
    "node_modules/@nodelib/fs.scandir": {
      "version": "2.1.5",
      "resolved": "https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz",
      "integrity": "sha512-vq24Bq3ym5HEQm2NKCr3yXDwjc7vTsEThRDnkp2DK9p1uqLR+DHurm/NOTo0KG7HYHU7eppKZj3MyqYuMBf62g==",
      "dev": true,
      "dependencies": {
        "@nodelib/fs.stat": "2.0.5",
        "run-parallel": "^1.1.9"
      },
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/@nodelib/fs.stat": {
      "version": "2.0.5",
      "resolved": "https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz",
      "integrity": "sha512-RkhPPp2zrqDAQA/2jNhnztcPAlv64XdhIp7a7454A5ovI7Bukxgt7MX7udwAu3zg1DcpPU0rz3VV1SeaqvY4+A==",
      "dev": true,
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/@nodelib/fs.walk": {
      "version": "1.2.8",
      "resolved": "https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz",
      "integrity": "sha512-oGB+UxlgWcgQkgwo8GcEGwemoTFt3FIO9ababBmaGwXIoBKZ+GTy0pP185beGg7Llih/NSHSV2XAs1lnznocSg==",
      "dev": true,
      "dependencies": {
        "@nodelib/fs.scandir": "2.1.5",
        "fastq": "^1.6.0"
      },
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/@pkgjs/parseargs": {
      "version": "0.11.0",
      "resolved": "https://registry.npmjs.org/@pkgjs/parseargs/-/parseargs-0.11.0.tgz",
      "integrity": "sha512-+1VkjdD0QBLPodGrJUeqarH8VAIvQODIbwh9XpP5Syisf7YoQgsJKPNFoqqLQlu+VQ/tVSshMR6loPMn8U+dPg==",
      "dev": true,
      "optional": true,
      "engines": {
        "node": ">=14"
      }
    },
    "node_modules/@react-leaflet/core": {
      "version": "3.0.0",
      "resolved": "https://registry.npmjs.org/@react-leaflet/core/-/core-3.0.0.tgz",
      "integrity": "sha512-3EWmekh4Nz+pGcr+xjf0KNyYfC3U2JjnkWsh0zcqaexYqmmB5ZhH37kz41JXGmKzpaMZCnPofBBm64i+YrEvGQ==",
      "license": "Hippocratic-2.1",
      "peerDependencies": {
        "leaflet": "^1.9.0",
        "react": "^19.0.0",
        "react-dom": "^19.0.0"
      }
    },
    "node_modules/@rollup/rollup-android-arm-eabi": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-android-arm-eabi/-/rollup-android-arm-eabi-4.24.0.tgz",
      "integrity": "sha512-Q6HJd7Y6xdB48x8ZNVDOqsbh2uByBhgK8PiQgPhwkIw/HC/YX5Ghq2mQY5sRMZWHb3VsFkWooUVOZHKr7DmDIA==",
      "cpu": [
        "arm"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "android"
      ]
    },
    "node_modules/@rollup/rollup-android-arm64": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-android-arm64/-/rollup-android-arm64-4.24.0.tgz",
      "integrity": "sha512-ijLnS1qFId8xhKjT81uBHuuJp2lU4x2yxa4ctFPtG+MqEE6+C5f/+X/bStmxapgmwLwiL3ih122xv8kVARNAZA==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "android"
      ]
    },
    "node_modules/@rollup/rollup-darwin-arm64": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-darwin-arm64/-/rollup-darwin-arm64-4.24.0.tgz",
      "integrity": "sha512-bIv+X9xeSs1XCk6DVvkO+S/z8/2AMt/2lMqdQbMrmVpgFvXlmde9mLcbQpztXm1tajC3raFDqegsH18HQPMYtA==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "darwin"
      ]
    },
    "node_modules/@rollup/rollup-darwin-x64": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-darwin-x64/-/rollup-darwin-x64-4.24.0.tgz",
      "integrity": "sha512-X6/nOwoFN7RT2svEQWUsW/5C/fYMBe4fnLK9DQk4SX4mgVBiTA9h64kjUYPvGQ0F/9xwJ5U5UfTbl6BEjaQdBQ==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "darwin"
      ]
    },
    "node_modules/@rollup/rollup-linux-arm-gnueabihf": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-arm-gnueabihf/-/rollup-linux-arm-gnueabihf-4.24.0.tgz",
      "integrity": "sha512-0KXvIJQMOImLCVCz9uvvdPgfyWo93aHHp8ui3FrtOP57svqrF/roSSR5pjqL2hcMp0ljeGlU4q9o/rQaAQ3AYA==",
      "cpu": [
        "arm"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ]
    },
    "node_modules/@rollup/rollup-linux-arm-musleabihf": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-arm-musleabihf/-/rollup-linux-arm-musleabihf-4.24.0.tgz",
      "integrity": "sha512-it2BW6kKFVh8xk/BnHfakEeoLPv8STIISekpoF+nBgWM4d55CZKc7T4Dx1pEbTnYm/xEKMgy1MNtYuoA8RFIWw==",
      "cpu": [
        "arm"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ]
    },
    "node_modules/@rollup/rollup-linux-arm64-gnu": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-arm64-gnu/-/rollup-linux-arm64-gnu-4.24.0.tgz",
      "integrity": "sha512-i0xTLXjqap2eRfulFVlSnM5dEbTVque/3Pi4g2y7cxrs7+a9De42z4XxKLYJ7+OhE3IgxvfQM7vQc43bwTgPwA==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ]
    },
    "node_modules/@rollup/rollup-linux-arm64-musl": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-arm64-musl/-/rollup-linux-arm64-musl-4.24.0.tgz",
      "integrity": "sha512-9E6MKUJhDuDh604Qco5yP/3qn3y7SLXYuiC0Rpr89aMScS2UAmK1wHP2b7KAa1nSjWJc/f/Lc0Wl1L47qjiyQw==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ]
    },
    "node_modules/@rollup/rollup-linux-powerpc64le-gnu": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-powerpc64le-gnu/-/rollup-linux-powerpc64le-gnu-4.24.0.tgz",
      "integrity": "sha512-2XFFPJ2XMEiF5Zi2EBf4h73oR1V/lycirxZxHZNc93SqDN/IWhYYSYj8I9381ikUFXZrz2v7r2tOVk2NBwxrWw==",
      "cpu": [
        "ppc64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ]
    },
    "node_modules/@rollup/rollup-linux-riscv64-gnu": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-riscv64-gnu/-/rollup-linux-riscv64-gnu-4.24.0.tgz",
      "integrity": "sha512-M3Dg4hlwuntUCdzU7KjYqbbd+BLq3JMAOhCKdBE3TcMGMZbKkDdJ5ivNdehOssMCIokNHFOsv7DO4rlEOfyKpg==",
      "cpu": [
        "riscv64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ]
    },
    "node_modules/@rollup/rollup-linux-s390x-gnu": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-s390x-gnu/-/rollup-linux-s390x-gnu-4.24.0.tgz",
      "integrity": "sha512-mjBaoo4ocxJppTorZVKWFpy1bfFj9FeCMJqzlMQGjpNPY9JwQi7OuS1axzNIk0nMX6jSgy6ZURDZ2w0QW6D56g==",
      "cpu": [
        "s390x"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ]
    },
    "node_modules/@rollup/rollup-linux-x64-gnu": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-x64-gnu/-/rollup-linux-x64-gnu-4.24.0.tgz",
      "integrity": "sha512-ZXFk7M72R0YYFN5q13niV0B7G8/5dcQ9JDp8keJSfr3GoZeXEoMHP/HlvqROA3OMbMdfr19IjCeNAnPUG93b6A==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ]
    },
    "node_modules/@rollup/rollup-linux-x64-musl": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-x64-musl/-/rollup-linux-x64-musl-4.24.0.tgz",
      "integrity": "sha512-w1i+L7kAXZNdYl+vFvzSZy8Y1arS7vMgIy8wusXJzRrPyof5LAb02KGr1PD2EkRcl73kHulIID0M501lN+vobQ==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "linux"
      ]
    },
    "node_modules/@rollup/rollup-win32-arm64-msvc": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-win32-arm64-msvc/-/rollup-win32-arm64-msvc-4.24.0.tgz",
      "integrity": "sha512-VXBrnPWgBpVDCVY6XF3LEW0pOU51KbaHhccHw6AS6vBWIC60eqsH19DAeeObl+g8nKAz04QFdl/Cefta0xQtUQ==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "win32"
      ]
    },
    "node_modules/@rollup/rollup-win32-ia32-msvc": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-win32-ia32-msvc/-/rollup-win32-ia32-msvc-4.24.0.tgz",
      "integrity": "sha512-xrNcGDU0OxVcPTH/8n/ShH4UevZxKIO6HJFK0e15XItZP2UcaiLFd5kiX7hJnqCbSztUF8Qot+JWBC/QXRPYWQ==",
      "cpu": [
        "ia32"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "win32"
      ]
    },
    "node_modules/@rollup/rollup-win32-x64-msvc": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/@rollup/rollup-win32-x64-msvc/-/rollup-win32-x64-msvc-4.24.0.tgz",
      "integrity": "sha512-fbMkAF7fufku0N2dE5TBXcNlg0pt0cJue4xBRE2Qc5Vqikxr4VCgKj/ht6SMdFcOacVA9rqF70APJ8RN/4vMJw==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "optional": true,
      "os": [
        "win32"
      ]
    },
    "node_modules/@supabase/auth-js": {
      "version": "2.71.1",
      "resolved": "https://registry.npmjs.org/@supabase/auth-js/-/auth-js-2.71.1.tgz",
      "integrity": "sha512-mMIQHBRc+SKpZFRB2qtupuzulaUhFYupNyxqDj5Jp/LyPvcWvjaJzZzObv6URtL/O6lPxkanASnotGtNpS3H2Q==",
      "dependencies": {
        "@supabase/node-fetch": "^2.6.14"
      }
    },
    "node_modules/@supabase/functions-js": {
      "version": "2.4.6",
      "resolved": "https://registry.npmjs.org/@supabase/functions-js/-/functions-js-2.4.6.tgz",
      "integrity": "sha512-bhjZ7rmxAibjgmzTmQBxJU6ZIBCCJTc3Uwgvdi4FewueUTAGO5hxZT1Sj6tiD+0dSXf9XI87BDdJrg12z8Uaew==",
      "dependencies": {
        "@supabase/node-fetch": "^2.6.14"
      }
    },
    "node_modules/@supabase/node-fetch": {
      "version": "2.6.15",
      "resolved": "https://registry.npmjs.org/@supabase/node-fetch/-/node-fetch-2.6.15.tgz",
      "integrity": "sha512-1ibVeYUacxWYi9i0cf5efil6adJ9WRyZBLivgjs+AUpewx1F3xPi7gLgaASI2SmIQxPoCEjAsLAzKPgMJVgOUQ==",
      "dependencies": {
        "whatwg-url": "^5.0.0"
      },
      "engines": {
        "node": "4.x || >=6.0.0"
      }
    },
    "node_modules/@supabase/postgrest-js": {
      "version": "1.21.4",
      "resolved": "https://registry.npmjs.org/@supabase/postgrest-js/-/postgrest-js-1.21.4.tgz",
      "integrity": "sha512-TxZCIjxk6/dP9abAi89VQbWWMBbybpGWyvmIzTd79OeravM13OjR/YEYeyUOPcM1C3QyvXkvPZhUfItvmhY1IQ==",
      "dependencies": {
        "@supabase/node-fetch": "^2.6.14"
      }
    },
    "node_modules/@supabase/realtime-js": {
      "version": "2.15.5",
      "resolved": "https://registry.npmjs.org/@supabase/realtime-js/-/realtime-js-2.15.5.tgz",
      "integrity": "sha512-/Rs5Vqu9jejRD8ZeuaWXebdkH+J7V6VySbCZ/zQM93Ta5y3mAmocjioa/nzlB6qvFmyylUgKVS1KpE212t30OA==",
      "dependencies": {
        "@supabase/node-fetch": "^2.6.13",
        "@types/phoenix": "^1.6.6",
        "@types/ws": "^8.18.1",
        "ws": "^8.18.2"
      }
    },
    "node_modules/@supabase/storage-js": {
      "version": "2.12.1",
      "resolved": "https://registry.npmjs.org/@supabase/storage-js/-/storage-js-2.12.1.tgz",
      "integrity": "sha512-QWg3HV6Db2J81VQx0PqLq0JDBn4Q8B1FYn1kYcbla8+d5WDmTdwwMr+EJAxNOSs9W4mhKMv+EYCpCrTFlTj4VQ==",
      "dependencies": {
        "@supabase/node-fetch": "^2.6.14"
      }
    },
    "node_modules/@supabase/supabase-js": {
      "version": "2.57.4",
      "resolved": "https://registry.npmjs.org/@supabase/supabase-js/-/supabase-js-2.57.4.tgz",
      "integrity": "sha512-LcbTzFhHYdwfQ7TRPfol0z04rLEyHabpGYANME6wkQ/kLtKNmI+Vy+WEM8HxeOZAtByUFxoUTTLwhXmrh+CcVw==",
      "dependencies": {
        "@supabase/auth-js": "2.71.1",
        "@supabase/functions-js": "2.4.6",
        "@supabase/node-fetch": "2.6.15",
        "@supabase/postgrest-js": "1.21.4",
        "@supabase/realtime-js": "2.15.5",
        "@supabase/storage-js": "2.12.1"
      }
    },
    "node_modules/@types/babel__core": {
      "version": "7.20.5",
      "resolved": "https://registry.npmjs.org/@types/babel__core/-/babel__core-7.20.5.tgz",
      "integrity": "sha512-qoQprZvz5wQFJwMDqeseRXWv3rqMvhgpbXFfVyWhbx9X47POIA6i/+dXefEmZKoAgOaTdaIgNSMqMIU61yRyzA==",
      "dev": true,
      "dependencies": {
        "@babel/parser": "^7.20.7",
        "@babel/types": "^7.20.7",
        "@types/babel__generator": "*",
        "@types/babel__template": "*",
        "@types/babel__traverse": "*"
      }
    },
    "node_modules/@types/babel__generator": {
      "version": "7.6.8",
      "resolved": "https://registry.npmjs.org/@types/babel__generator/-/babel__generator-7.6.8.tgz",
      "integrity": "sha512-ASsj+tpEDsEiFr1arWrlN6V3mdfjRMZt6LtK/Vp/kreFLnr5QH5+DhvD5nINYZXzwJvXeGq+05iUXcAzVrqWtw==",
      "dev": true,
      "dependencies": {
        "@babel/types": "^7.0.0"
      }
    },
    "node_modules/@types/babel__template": {
      "version": "7.4.4",
      "resolved": "https://registry.npmjs.org/@types/babel__template/-/babel__template-7.4.4.tgz",
      "integrity": "sha512-h/NUaSyG5EyxBIp8YRxo4RMe2/qQgvyowRwVMzhYhBCONbW8PUsg4lkFMrhgZhUe5z3L3MiLDuvyJ/CaPa2A8A==",
      "dev": true,
      "dependencies": {
        "@babel/parser": "^7.1.0",
        "@babel/types": "^7.0.0"
      }
    },
    "node_modules/@types/babel__traverse": {
      "version": "7.20.6",
      "resolved": "https://registry.npmjs.org/@types/babel__traverse/-/babel__traverse-7.20.6.tgz",
      "integrity": "sha512-r1bzfrm0tomOI8g1SzvCaQHo6Lcv6zu0EA+W2kHrt8dyrHQxGzBBL4kdkzIS+jBMV+EYcMAEAqXqYaLJq5rOZg==",
      "dev": true,
      "dependencies": {
        "@babel/types": "^7.20.7"
      }
    },
    "node_modules/@types/estree": {
      "version": "1.0.6",
      "resolved": "https://registry.npmjs.org/@types/estree/-/estree-1.0.6.tgz",
      "integrity": "sha512-AYnb1nQyY49te+VRAVgmzfcgjYS91mY5P0TKUDCLEM+gNnA+3T6rWITXRLYCpahpqSQbN5cE+gHpnPyXjHWxcw==",
      "dev": true
    },
    "node_modules/@types/geojson": {
      "version": "7946.0.16",
      "resolved": "https://registry.npmjs.org/@types/geojson/-/geojson-7946.0.16.tgz",
      "integrity": "sha512-6C8nqWur3j98U6+lXDfTUWIfgvZU+EumvpHKcYjujKH7woYyLj2sUmff0tRhrqM7BohUw7Pz3ZB1jj2gW9Fvmg==",
      "license": "MIT"
    },
    "node_modules/@types/json-schema": {
      "version": "7.0.15",
      "resolved": "https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.15.tgz",
      "integrity": "sha512-5+fP8P8MFNC+AyZCDxrB2pkZFPGzqQWUzpSeuuVLvm8VMcorNYavBqoFcxK8bQz4Qsbn4oUEEem4wDLfcysGHA==",
      "dev": true
    },
    "node_modules/@types/leaflet": {
      "version": "1.9.21",
      "resolved": "https://registry.npmjs.org/@types/leaflet/-/leaflet-1.9.21.tgz",
      "integrity": "sha512-TbAd9DaPGSnzp6QvtYngntMZgcRk+igFELwR2N99XZn7RXUdKgsXMR+28bUO0rPsWp8MIu/f47luLIQuSLYv/w==",
      "license": "MIT",
      "dependencies": {
        "@types/geojson": "*"
      }
    },
    "node_modules/@types/node": {
      "version": "24.3.1",
      "resolved": "https://registry.npmjs.org/@types/node/-/node-24.3.1.tgz",
      "integrity": "sha512-3vXmQDXy+woz+gnrTvuvNrPzekOi+Ds0ReMxw0LzBiK3a+1k0kQn9f2NWk+lgD4rJehFUmYy2gMhJ2ZI+7YP9g==",
      "dependencies": {
        "undici-types": "~7.10.0"
      }
    },
    "node_modules/@types/phoenix": {
      "version": "1.6.6",
      "resolved": "https://registry.npmjs.org/@types/phoenix/-/phoenix-1.6.6.tgz",
      "integrity": "sha512-PIzZZlEppgrpoT2QgbnDU+MMzuR6BbCjllj0bM70lWoejMeNJAxCchxnv7J3XFkI8MpygtRpzXrIlmWUBclP5A=="
    },
    "node_modules/@types/prop-types": {
      "version": "15.7.13",
      "resolved": "https://registry.npmjs.org/@types/prop-types/-/prop-types-15.7.13.tgz",
      "integrity": "sha512-hCZTSvwbzWGvhqxp/RqVqwU999pBf2vp7hzIjiYOsl8wqOmUxkQ6ddw1cV3l8811+kdUFus/q4d1Y3E3SyEifA==",
      "dev": true
    },
    "node_modules/@types/react": {
      "version": "18.3.11",
      "resolved": "https://registry.npmjs.org/@types/react/-/react-18.3.11.tgz",
      "integrity": "sha512-r6QZ069rFTjrEYgFdOck1gK7FLVsgJE7tTz0pQBczlBNUhBNk0MQH4UbnFSwjpQLMkLzgqvBBa+qGpLje16eTQ==",
      "dev": true,
      "dependencies": {
        "@types/prop-types": "*",
        "csstype": "^3.0.2"
      }
    },
    "node_modules/@types/react-dom": {
      "version": "18.3.0",
      "resolved": "https://registry.npmjs.org/@types/react-dom/-/react-dom-18.3.0.tgz",
      "integrity": "sha512-EhwApuTmMBmXuFOikhQLIBUn6uFg81SwLMOAUgodJF14SOBOCMdU04gDoYi0WOJJHD144TL32z4yDqCW3dnkQg==",
      "dev": true,
      "dependencies": {
        "@types/react": "*"
      }
    },
    "node_modules/@types/ws": {
      "version": "8.18.1",
      "resolved": "https://registry.npmjs.org/@types/ws/-/ws-8.18.1.tgz",
      "integrity": "sha512-ThVF6DCVhA8kUGy+aazFQ4kXQ7E1Ty7A3ypFOe0IcJV8O/M511G99AW24irKrW56Wt44yG9+ij8FaqoBGkuBXg==",
      "dependencies": {
        "@types/node": "*"
      }
    },
    "node_modules/@typescript-eslint/eslint-plugin": {
      "version": "8.8.1",
      "resolved": "https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-8.8.1.tgz",
      "integrity": "sha512-xfvdgA8AP/vxHgtgU310+WBnLB4uJQ9XdyP17RebG26rLtDrQJV3ZYrcopX91GrHmMoH8bdSwMRh2a//TiJ1jQ==",
      "dev": true,
      "dependencies": {
        "@eslint-community/regexpp": "^4.10.0",
        "@typescript-eslint/scope-manager": "8.8.1",
        "@typescript-eslint/type-utils": "8.8.1",
        "@typescript-eslint/utils": "8.8.1",
        "@typescript-eslint/visitor-keys": "8.8.1",
        "graphemer": "^1.4.0",
        "ignore": "^5.3.1",
        "natural-compare": "^1.4.0",
        "ts-api-utils": "^1.3.0"
      },
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/typescript-eslint"
      },
      "peerDependencies": {
        "@typescript-eslint/parser": "^8.0.0 || ^8.0.0-alpha.0",
        "eslint": "^8.57.0 || ^9.0.0"
      },
      "peerDependenciesMeta": {
        "typescript": {
          "optional": true
        }
      }
    },
    "node_modules/@typescript-eslint/parser": {
      "version": "8.8.1",
      "resolved": "https://registry.npmjs.org/@typescript-eslint/parser/-/parser-8.8.1.tgz",
      "integrity": "sha512-hQUVn2Lij2NAxVFEdvIGxT9gP1tq2yM83m+by3whWFsWC+1y8pxxxHUFE1UqDu2VsGi2i6RLcv4QvouM84U+ow==",
      "dev": true,
      "dependencies": {
        "@typescript-eslint/scope-manager": "8.8.1",
        "@typescript-eslint/types": "8.8.1",
        "@typescript-eslint/typescript-estree": "8.8.1",
        "@typescript-eslint/visitor-keys": "8.8.1",
        "debug": "^4.3.4"
      },
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/typescript-eslint"
      },
      "peerDependencies": {
        "eslint": "^8.57.0 || ^9.0.0"
      },
      "peerDependenciesMeta": {
        "typescript": {
          "optional": true
        }
      }
    },
    "node_modules/@typescript-eslint/scope-manager": {
      "version": "8.8.1",
      "resolved": "https://registry.npmjs.org/@typescript-eslint/scope-manager/-/scope-manager-8.8.1.tgz",
      "integrity": "sha512-X4JdU+66Mazev/J0gfXlcC/dV6JI37h+93W9BRYXrSn0hrE64IoWgVkO9MSJgEzoWkxONgaQpICWg8vAN74wlA==",
      "dev": true,
      "dependencies": {
        "@typescript-eslint/types": "8.8.1",
        "@typescript-eslint/visitor-keys": "8.8.1"
      },
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/typescript-eslint"
      }
    },
    "node_modules/@typescript-eslint/type-utils": {
      "version": "8.8.1",
      "resolved": "https://registry.npmjs.org/@typescript-eslint/type-utils/-/type-utils-8.8.1.tgz",
      "integrity": "sha512-qSVnpcbLP8CALORf0za+vjLYj1Wp8HSoiI8zYU5tHxRVj30702Z1Yw4cLwfNKhTPWp5+P+k1pjmD5Zd1nhxiZA==",
      "dev": true,
      "dependencies": {
        "@typescript-eslint/typescript-estree": "8.8.1",
        "@typescript-eslint/utils": "8.8.1",
        "debug": "^4.3.4",
        "ts-api-utils": "^1.3.0"
      },
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/typescript-eslint"
      },
      "peerDependenciesMeta": {
        "typescript": {
          "optional": true
        }
      }
    },
    "node_modules/@typescript-eslint/types": {
      "version": "8.8.1",
      "resolved": "https://registry.npmjs.org/@typescript-eslint/types/-/types-8.8.1.tgz",
      "integrity": "sha512-WCcTP4SDXzMd23N27u66zTKMuEevH4uzU8C9jf0RO4E04yVHgQgW+r+TeVTNnO1KIfrL8ebgVVYYMMO3+jC55Q==",
      "dev": true,
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/typescript-eslint"
      }
    },
    "node_modules/@typescript-eslint/typescript-estree": {
      "version": "8.8.1",
      "resolved": "https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-8.8.1.tgz",
      "integrity": "sha512-A5d1R9p+X+1js4JogdNilDuuq+EHZdsH9MjTVxXOdVFfTJXunKJR/v+fNNyO4TnoOn5HqobzfRlc70NC6HTcdg==",
      "dev": true,
      "dependencies": {
        "@typescript-eslint/types": "8.8.1",
        "@typescript-eslint/visitor-keys": "8.8.1",
        "debug": "^4.3.4",
        "fast-glob": "^3.3.2",
        "is-glob": "^4.0.3",
        "minimatch": "^9.0.4",
        "semver": "^7.6.0",
        "ts-api-utils": "^1.3.0"
      },
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/typescript-eslint"
      },
      "peerDependenciesMeta": {
        "typescript": {
          "optional": true
        }
      }
    },
    "node_modules/@typescript-eslint/typescript-estree/node_modules/brace-expansion": {
      "version": "2.0.1",
      "resolved": "https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz",
      "integrity": "sha512-XnAIvQ8eM+kC6aULx6wuQiwVsnzsi9d3WxzV3FpWTGA19F621kwdbsAcFKXgKUHZWsy+mY6iL1sHTxWEFCytDA==",
      "dev": true,
      "dependencies": {
        "balanced-match": "^1.0.0"
      }
    },
    "node_modules/@typescript-eslint/typescript-estree/node_modules/minimatch": {
      "version": "9.0.5",
      "resolved": "https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz",
      "integrity": "sha512-G6T0ZX48xgozx7587koeX9Ys2NYy6Gmv//P89sEte9V9whIapMNF4idKxnW2QtCcLiTWlb/wfCabAtAFWhhBow==",
      "dev": true,
      "dependencies": {
        "brace-expansion": "^2.0.1"
      },
      "engines": {
        "node": ">=16 || 14 >=14.17"
      },
      "funding": {
        "url": "https://github.com/sponsors/isaacs"
      }
    },
    "node_modules/@typescript-eslint/typescript-estree/node_modules/semver": {
      "version": "7.6.3",
      "resolved": "https://registry.npmjs.org/semver/-/semver-7.6.3.tgz",
      "integrity": "sha512-oVekP1cKtI+CTDvHWYFUcMtsK/00wmAEfyqKfNdARm8u1wNVhSgaX7A8d4UuIlUI5e84iEwOhs7ZPYRmzU9U6A==",
      "dev": true,
      "bin": {
        "semver": "bin/semver.js"
      },
      "engines": {
        "node": ">=10"
      }
    },
    "node_modules/@typescript-eslint/utils": {
      "version": "8.8.1",
      "resolved": "https://registry.npmjs.org/@typescript-eslint/utils/-/utils-8.8.1.tgz",
      "integrity": "sha512-/QkNJDbV0bdL7H7d0/y0qBbV2HTtf0TIyjSDTvvmQEzeVx8jEImEbLuOA4EsvE8gIgqMitns0ifb5uQhMj8d9w==",
      "dev": true,
      "dependencies": {
        "@eslint-community/eslint-utils": "^4.4.0",
        "@typescript-eslint/scope-manager": "8.8.1",
        "@typescript-eslint/types": "8.8.1",
        "@typescript-eslint/typescript-estree": "8.8.1"
      },
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/typescript-eslint"
      },
      "peerDependencies": {
        "eslint": "^8.57.0 || ^9.0.0"
      }
    },
    "node_modules/@typescript-eslint/visitor-keys": {
      "version": "8.8.1",
      "resolved": "https://registry.npmjs.org/@typescript-eslint/visitor-keys/-/visitor-keys-8.8.1.tgz",
      "integrity": "sha512-0/TdC3aeRAsW7MDvYRwEc1Uwm0TIBfzjPFgg60UU2Haj5qsCs9cc3zNgY71edqE3LbWfF/WoZQd3lJoDXFQpag==",
      "dev": true,
      "dependencies": {
        "@typescript-eslint/types": "8.8.1",
        "eslint-visitor-keys": "^3.4.3"
      },
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/typescript-eslint"
      }
    },
    "node_modules/@typescript-eslint/visitor-keys/node_modules/eslint-visitor-keys": {
      "version": "3.4.3",
      "resolved": "https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-3.4.3.tgz",
      "integrity": "sha512-wpc+LXeiyiisxPlEkUzU6svyS1frIO3Mgxj1fdy7Pm8Ygzguax2N3Fa/D/ag1WqbOprdI+uY6wMUl8/a2G+iag==",
      "dev": true,
      "engines": {
        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
      },
      "funding": {
        "url": "https://opencollective.com/eslint"
      }
    },
    "node_modules/@vitejs/plugin-react": {
      "version": "4.3.2",
      "resolved": "https://registry.npmjs.org/@vitejs/plugin-react/-/plugin-react-4.3.2.tgz",
      "integrity": "sha512-hieu+o05v4glEBucTcKMK3dlES0OeJlD9YVOAPraVMOInBCwzumaIFiUjr4bHK7NPgnAHgiskUoceKercrN8vg==",
      "dev": true,
      "dependencies": {
        "@babel/core": "^7.25.2",
        "@babel/plugin-transform-react-jsx-self": "^7.24.7",
        "@babel/plugin-transform-react-jsx-source": "^7.24.7",
        "@types/babel__core": "^7.20.5",
        "react-refresh": "^0.14.2"
      },
      "engines": {
        "node": "^14.18.0 || >=16.0.0"
      },
      "peerDependencies": {
        "vite": "^4.2.0 || ^5.0.0"
      }
    },
    "node_modules/acorn": {
      "version": "8.12.1",
      "resolved": "https://registry.npmjs.org/acorn/-/acorn-8.12.1.tgz",
      "integrity": "sha512-tcpGyI9zbizT9JbV6oYE477V6mTlXvvi0T0G3SNIYE2apm/G5huBa1+K89VGeovbg+jycCrfhl3ADxErOuO6Jg==",
      "dev": true,
      "bin": {
        "acorn": "bin/acorn"
      },
      "engines": {
        "node": ">=0.4.0"
      }
    },
    "node_modules/acorn-jsx": {
      "version": "5.3.2",
      "resolved": "https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.2.tgz",
      "integrity": "sha512-rq9s+JNhf0IChjtDXxllJ7g41oZk5SlXtp0LHwyA5cejwn7vKmKp4pPri6YEePv2PU65sAsegbXtIinmDFDXgQ==",
      "dev": true,
      "peerDependencies": {
        "acorn": "^6.0.0 || ^7.0.0 || ^8.0.0"
      }
    },
    "node_modules/agent-base": {
      "version": "6.0.2",
      "resolved": "https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz",
      "integrity": "sha512-RZNwNclF7+MS/8bDg70amg32dyeZGZxiDuQmZxKLAlQjr3jGyLx+4Kkk58UO7D2QdgFIQCovuSuZESne6RG6XQ==",
      "license": "MIT",
      "dependencies": {
        "debug": "4"
      },
      "engines": {
        "node": ">= 6.0.0"
      }
    },
    "node_modules/ajv": {
      "version": "6.12.6",
      "resolved": "https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz",
      "integrity": "sha512-j3fVLgvTo527anyYyJOGTYJbG+vnnQYvE0m5mmkc1TK+nxAppkCLMIL0aZ4dblVCNoGShhm+kzE4ZUykBoMg4g==",
      "dev": true,
      "dependencies": {
        "fast-deep-equal": "^3.1.1",
        "fast-json-stable-stringify": "^2.0.0",
        "json-schema-traverse": "^0.4.1",
        "uri-js": "^4.2.2"
      },
      "funding": {
        "type": "github",
        "url": "https://github.com/sponsors/epoberezkin"
      }
    },
    "node_modules/ansi-regex": {
      "version": "6.1.0",
      "resolved": "https://registry.npmjs.org/ansi-regex/-/ansi-regex-6.1.0.tgz",
      "integrity": "sha512-7HSX4QQb4CspciLpVFwyRe79O3xsIZDDLER21kERQ71oaPodF8jL725AgJMFAYbooIqolJoRLuM81SpeUkpkvA==",
      "dev": true,
      "engines": {
        "node": ">=12"
      },
      "funding": {
        "url": "https://github.com/chalk/ansi-regex?sponsor=1"
      }
    },
    "node_modules/ansi-styles": {
      "version": "3.2.1",
      "resolved": "https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz",
      "integrity": "sha512-VT0ZI6kZRdTh8YyJw3SMbYm/u+NqfsAxEpWO0Pf9sq8/e94WxxOpPKx9FR1FlyCtOVDNOQ+8ntlqFxiRc+r5qA==",
      "dev": true,
      "dependencies": {
        "color-convert": "^1.9.0"
      },
      "engines": {
        "node": ">=4"
      }
    },
    "node_modules/any-promise": {
      "version": "1.3.0",
      "resolved": "https://registry.npmjs.org/any-promise/-/any-promise-1.3.0.tgz",
      "integrity": "sha512-7UvmKalWRt1wgjL1RrGxoSJW/0QZFIegpeGvZG9kjp8vrRu55XTHbwnqq2GpXm9uLbcuhxm3IqX9OB4MZR1b2A==",
      "dev": true
    },
    "node_modules/anymatch": {
      "version": "3.1.3",
      "resolved": "https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz",
      "integrity": "sha512-KMReFUr0B4t+D+OBkjR3KYqvocp2XaSzO55UcB6mgQMd3KbcE+mWTyvVV7D/zsdEbNnV6acZUutkiHQXvTr1Rw==",
      "dev": true,
      "dependencies": {
        "normalize-path": "^3.0.0",
        "picomatch": "^2.0.4"
      },
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/arg": {
      "version": "5.0.2",
      "resolved": "https://registry.npmjs.org/arg/-/arg-5.0.2.tgz",
      "integrity": "sha512-PYjyFOLKQ9y57JvQ6QLo8dAgNqswh8M1RMJYdQduT6xbWSgK36P/Z/v+p888pM69jMMfS8Xd8F6I1kQ/I9HUGg==",
      "dev": true
    },
    "node_modules/argparse": {
      "version": "2.0.1",
      "resolved": "https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz",
      "integrity": "sha512-8+9WqebbFzpX9OR+Wa6O29asIogeRMzcGtAINdpMHHyAg10f05aSFVBbcEqGf/PXw1EjAZ+q2/bEBg3DvurK3Q==",
      "dev": true
    },
    "node_modules/asynckit": {
      "version": "0.4.0",
      "resolved": "https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz",
      "integrity": "sha512-Oei9OH4tRh0YqU3GxhX79dM/mwVgvbZJaSNaRk+bshkj0S5cfHcgYakreBjrHwatXKbz+IoIdYLxrKim2MjW0Q==",
      "license": "MIT"
    },
    "node_modules/autoprefixer": {
      "version": "10.4.20",
      "resolved": "https://registry.npmjs.org/autoprefixer/-/autoprefixer-10.4.20.tgz",
      "integrity": "sha512-XY25y5xSv/wEoqzDyXXME4AFfkZI0P23z6Fs3YgymDnKJkCGOnkL0iTxCa85UTqaSgfcqyf3UA6+c7wUvx/16g==",
      "dev": true,
      "funding": [
        {
          "type": "opencollective",
          "url": "https://opencollective.com/postcss/"
        },
        {
          "type": "tidelift",
          "url": "https://tidelift.com/funding/github/npm/autoprefixer"
        },
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "dependencies": {
        "browserslist": "^4.23.3",
        "caniuse-lite": "^1.0.30001646",
        "fraction.js": "^4.3.7",
        "normalize-range": "^0.1.2",
        "picocolors": "^1.0.1",
        "postcss-value-parser": "^4.2.0"
      },
      "bin": {
        "autoprefixer": "bin/autoprefixer"
      },
      "engines": {
        "node": "^10 || ^12 || >=14"
      },
      "peerDependencies": {
        "postcss": "^8.1.0"
      }
    },
    "node_modules/axios": {
      "version": "1.17.0",
      "resolved": "https://registry.npmjs.org/axios/-/axios-1.17.0.tgz",
      "integrity": "sha512-J8SwNxprqqpbfenehxWYXE7CW+wM1BB4w3+N+g+/Wx40xM4rsLrfPmHHxSWIxJLYDgSY/HqlFPIYb2/S3rxafw==",
      "license": "MIT",
      "dependencies": {
        "follow-redirects": "^1.16.0",
        "form-data": "^4.0.5",
        "https-proxy-agent": "^5.0.1",
        "proxy-from-env": "^2.1.0"
      }
    },
    "node_modules/balanced-match": {
      "version": "1.0.2",
      "resolved": "https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz",
      "integrity": "sha512-3oSeUO0TMV67hN1AmbXsK4yaqU7tjiHlbxRDZOpH0KW9+CeX4bRAaX0Anxt0tx2MrpRpWwQaPwIlISEJhYU5Pw==",
      "dev": true
    },
    "node_modules/binary-extensions": {
      "version": "2.3.0",
      "resolved": "https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.3.0.tgz",
      "integrity": "sha512-Ceh+7ox5qe7LJuLHoY0feh3pHuUDHAcRUeyL2VYghZwfpkNIy/+8Ocg0a3UuSoYzavmylwuLWQOf3hl0jjMMIw==",
      "dev": true,
      "engines": {
        "node": ">=8"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/brace-expansion": {
      "version": "1.1.11",
      "resolved": "https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz",
      "integrity": "sha512-iCuPHDFgrHX7H2vEI/5xpz07zSHB00TpugqhmYtVmMO6518mCuRMoOYFldEBl0g187ufozdaHgWKcYFb61qGiA==",
      "dev": true,
      "dependencies": {
        "balanced-match": "^1.0.0",
        "concat-map": "0.0.1"
      }
    },
    "node_modules/braces": {
      "version": "3.0.3",
      "resolved": "https://registry.npmjs.org/braces/-/braces-3.0.3.tgz",
      "integrity": "sha512-yQbXgO/OSZVD2IsiLlro+7Hf6Q18EJrKSEsdoMzKePKXct3gvD8oLcOQdIzGupr5Fj+EDe8gO/lxc1BzfMpxvA==",
      "dev": true,
      "dependencies": {
        "fill-range": "^7.1.1"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/browserslist": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/browserslist/-/browserslist-4.24.0.tgz",
      "integrity": "sha512-Rmb62sR1Zpjql25eSanFGEhAxcFwfA1K0GuQcLoaJBAcENegrQut3hYdhXFF1obQfiDyqIW/cLM5HSJ/9k884A==",
      "dev": true,
      "funding": [
        {
          "type": "opencollective",
          "url": "https://opencollective.com/browserslist"
        },
        {
          "type": "tidelift",
          "url": "https://tidelift.com/funding/github/npm/browserslist"
        },
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "dependencies": {
        "caniuse-lite": "^1.0.30001663",
        "electron-to-chromium": "^1.5.28",
        "node-releases": "^2.0.18",
        "update-browserslist-db": "^1.1.0"
      },
      "bin": {
        "browserslist": "cli.js"
      },
      "engines": {
        "node": "^6 || ^7 || ^8 || ^9 || ^10 || ^11 || ^12 || >=13.7"
      }
    },
    "node_modules/call-bind-apply-helpers": {
      "version": "1.0.2",
      "resolved": "https://registry.npmjs.org/call-bind-apply-helpers/-/call-bind-apply-helpers-1.0.2.tgz",
      "integrity": "sha512-Sp1ablJ0ivDkSzjcaJdxEunN5/XvksFJ2sMBFfq6x0ryhQV/2b/KwFe21cMpmHtPOSij8K99/wSfoEuTObmuMQ==",
      "license": "MIT",
      "dependencies": {
        "es-errors": "^1.3.0",
        "function-bind": "^1.1.2"
      },
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/callsites": {
      "version": "3.1.0",
      "resolved": "https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz",
      "integrity": "sha512-P8BjAsXvZS+VIDUI11hHCQEv74YT67YUi5JJFNWIqL235sBmjX4+qx9Muvls5ivyNENctx46xQLQ3aTuE7ssaQ==",
      "dev": true,
      "engines": {
        "node": ">=6"
      }
    },
    "node_modules/camelcase-css": {
      "version": "2.0.1",
      "resolved": "https://registry.npmjs.org/camelcase-css/-/camelcase-css-2.0.1.tgz",
      "integrity": "sha512-QOSvevhslijgYwRx6Rv7zKdMF8lbRmx+uQGx2+vDc+KI/eBnsy9kit5aj23AgGu3pa4t9AgwbnXWqS+iOY+2aA==",
      "dev": true,
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/caniuse-lite": {
      "version": "1.0.30001667",
      "resolved": "https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001667.tgz",
      "integrity": "sha512-7LTwJjcRkzKFmtqGsibMeuXmvFDfZq/nzIjnmgCGzKKRVzjD72selLDK1oPF/Oxzmt4fNcPvTDvGqSDG4tCALw==",
      "dev": true,
      "funding": [
        {
          "type": "opencollective",
          "url": "https://opencollective.com/browserslist"
        },
        {
          "type": "tidelift",
          "url": "https://tidelift.com/funding/github/npm/caniuse-lite"
        },
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ]
    },
    "node_modules/chalk": {
      "version": "2.4.2",
      "resolved": "https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz",
      "integrity": "sha512-Mti+f9lpJNcwF4tWV8/OrTTtF1gZi+f8FqlyAdouralcFWFQWF2+NgCHShjkCb+IFBLq9buZwE1xckQU4peSuQ==",
      "dev": true,
      "dependencies": {
        "ansi-styles": "^3.2.1",
        "escape-string-regexp": "^1.0.5",
        "supports-color": "^5.3.0"
      },
      "engines": {
        "node": ">=4"
      }
    },
    "node_modules/chokidar": {
      "version": "3.6.0",
      "resolved": "https://registry.npmjs.org/chokidar/-/chokidar-3.6.0.tgz",
      "integrity": "sha512-7VT13fmjotKpGipCW9JEQAusEPE+Ei8nl6/g4FBAmIm0GOOLMua9NDDo/DWp0ZAxCr3cPq5ZpBqmPAQgDda2Pw==",
      "dev": true,
      "dependencies": {
        "anymatch": "~3.1.2",
        "braces": "~3.0.2",
        "glob-parent": "~5.1.2",
        "is-binary-path": "~2.1.0",
        "is-glob": "~4.0.1",
        "normalize-path": "~3.0.0",
        "readdirp": "~3.6.0"
      },
      "engines": {
        "node": ">= 8.10.0"
      },
      "funding": {
        "url": "https://paulmillr.com/funding/"
      },
      "optionalDependencies": {
        "fsevents": "~2.3.2"
      }
    },
    "node_modules/chokidar/node_modules/glob-parent": {
      "version": "5.1.2",
      "resolved": "https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz",
      "integrity": "sha512-AOIgSQCepiJYwP3ARnGx+5VnTu2HBYdzbGP45eLw1vr3zB3vZLeyed1sC9hnbcOc9/SrMyM5RPQrkGz4aS9Zow==",
      "dev": true,
      "dependencies": {
        "is-glob": "^4.0.1"
      },
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/color-convert": {
      "version": "1.9.3",
      "resolved": "https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz",
      "integrity": "sha512-QfAUtd+vFdAtFQcC8CCyYt1fYWxSqAiK2cSD6zDB8N3cpsEBAvRxp9zOGg6G/SHHJYAT88/az/IuDGALsNVbGg==",
      "dev": true,
      "dependencies": {
        "color-name": "1.1.3"
      }
    },
    "node_modules/color-name": {
      "version": "1.1.3",
      "resolved": "https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz",
      "integrity": "sha512-72fSenhMw2HZMTVHeCA9KCmpEIbzWiQsjN+BHcBbS9vr1mtt+vJjPdksIBNUmKAW8TFUDPJK5SUU3QhE9NEXDw==",
      "dev": true
    },
    "node_modules/combined-stream": {
      "version": "1.0.8",
      "resolved": "https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.8.tgz",
      "integrity": "sha512-FQN4MRfuJeHf7cBbBMJFXhKSDq+2kAArBlmRBvcvFE5BB1HZKXtSFASDhdlz9zOYwxh8lDdnvmMOe/+5cdoEdg==",
      "license": "MIT",
      "dependencies": {
        "delayed-stream": "~1.0.0"
      },
      "engines": {
        "node": ">= 0.8"
      }
    },
    "node_modules/commander": {
      "version": "4.1.1",
      "resolved": "https://registry.npmjs.org/commander/-/commander-4.1.1.tgz",
      "integrity": "sha512-NOKm8xhkzAjzFx8B2v5OAHT+u5pRQc2UCa2Vq9jYL/31o2wi9mxBA7LIFs3sV5VSC49z6pEhfbMULvShKj26WA==",
      "dev": true,
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/concat-map": {
      "version": "0.0.1",
      "resolved": "https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz",
      "integrity": "sha512-/Srv4dswyQNBfohGpz9o6Yb3Gz3SrUDqBH5rTuhGR7ahtlbYKnVxw2bCFMRljaA7EXHaXZ8wsHdodFvbkhKmqg==",
      "dev": true
    },
    "node_modules/convert-source-map": {
      "version": "2.0.0",
      "resolved": "https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz",
      "integrity": "sha512-Kvp459HrV2FEJ1CAsi1Ku+MY3kasH19TFykTz2xWmMeq6bk2NU3XXvfJ+Q61m0xktWwt+1HSYf3JZsTms3aRJg==",
      "dev": true
    },
    "node_modules/cookie": {
      "version": "1.1.1",
      "resolved": "https://registry.npmjs.org/cookie/-/cookie-1.1.1.tgz",
      "integrity": "sha512-ei8Aos7ja0weRpFzJnEA9UHJ/7XQmqglbRwnf2ATjcB9Wq874VKH9kfjjirM6UhU2/E5fFYadylyhFldcqSidQ==",
      "license": "MIT",
      "engines": {
        "node": ">=18"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/express"
      }
    },
    "node_modules/cross-spawn": {
      "version": "7.0.3",
      "resolved": "https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz",
      "integrity": "sha512-iRDPJKUPVEND7dHPO8rkbOnPpyDygcDFtWjpeWNCgy8WP2rXcxXL8TskReQl6OrB2G7+UJrags1q15Fudc7G6w==",
      "dev": true,
      "dependencies": {
        "path-key": "^3.1.0",
        "shebang-command": "^2.0.0",
        "which": "^2.0.1"
      },
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/cssesc": {
      "version": "3.0.0",
      "resolved": "https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz",
      "integrity": "sha512-/Tb/JcjK111nNScGob5MNtsntNM1aCNUDipB/TkwZFhyDrrE47SOx/18wF2bbjgc3ZzCSKW1T5nt5EbFoAz/Vg==",
      "dev": true,
      "bin": {
        "cssesc": "bin/cssesc"
      },
      "engines": {
        "node": ">=4"
      }
    },
    "node_modules/csstype": {
      "version": "3.1.3",
      "resolved": "https://registry.npmjs.org/csstype/-/csstype-3.1.3.tgz",
      "integrity": "sha512-M1uQkMl8rQK/szD0LNhtqxIPLpimGm8sOBwU7lLnCpSbTyY3yeU1Vc7l4KT5zT4s/yOxHH5O7tIuuLOCnLADRw==",
      "dev": true
    },
    "node_modules/debug": {
      "version": "4.3.7",
      "resolved": "https://registry.npmjs.org/debug/-/debug-4.3.7.tgz",
      "integrity": "sha512-Er2nc/H7RrMXZBFCEim6TCmMk02Z8vLC2Rbi1KEBggpo0fS6l0S1nnapwmIi3yW/+GOJap1Krg4w0Hg80oCqgQ==",
      "dependencies": {
        "ms": "^2.1.3"
      },
      "engines": {
        "node": ">=6.0"
      },
      "peerDependenciesMeta": {
        "supports-color": {
          "optional": true
        }
      }
    },
    "node_modules/deep-is": {
      "version": "0.1.4",
      "resolved": "https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz",
      "integrity": "sha512-oIPzksmTg4/MriiaYGO+okXDT7ztn/w3Eptv/+gSIdMdKsJo0u4CfYNFJPy+4SKMuCqGw2wxnA+URMg3t8a/bQ==",
      "dev": true
    },
    "node_modules/delayed-stream": {
      "version": "1.0.0",
      "resolved": "https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz",
      "integrity": "sha512-ZySD7Nf91aLB0RxL4KGrKHBXl7Eds1DAmEdcoVawXnLD7SDhpNgtuII2aAkg7a7QS41jxPSZ17p4VdGnMHk3MQ==",
      "license": "MIT",
      "engines": {
        "node": ">=0.4.0"
      }
    },
    "node_modules/didyoumean": {
      "version": "1.2.2",
      "resolved": "https://registry.npmjs.org/didyoumean/-/didyoumean-1.2.2.tgz",
      "integrity": "sha512-gxtyfqMg7GKyhQmb056K7M3xszy/myH8w+B4RT+QXBQsvAOdc3XymqDDPHx1BgPgsdAA5SIifona89YtRATDzw==",
      "dev": true
    },
    "node_modules/dlv": {
      "version": "1.1.3",
      "resolved": "https://registry.npmjs.org/dlv/-/dlv-1.1.3.tgz",
      "integrity": "sha512-+HlytyjlPKnIG8XuRG8WvmBP8xs8P71y+SKKS6ZXWoEgLuePxtDoUEiH7WkdePWrQ5JBpE6aoVqfZfJUQkjXwA==",
      "dev": true
    },
    "node_modules/dunder-proto": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/dunder-proto/-/dunder-proto-1.0.1.tgz",
      "integrity": "sha512-KIN/nDJBQRcXw0MLVhZE9iQHmG68qAVIBg9CqmUYjmQIhgij9U5MFvrqkUL5FbtyyzZuOeOt0zdeRe4UY7ct+A==",
      "license": "MIT",
      "dependencies": {
        "call-bind-apply-helpers": "^1.0.1",
        "es-errors": "^1.3.0",
        "gopd": "^1.2.0"
      },
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/eastasianwidth": {
      "version": "0.2.0",
      "resolved": "https://registry.npmjs.org/eastasianwidth/-/eastasianwidth-0.2.0.tgz",
      "integrity": "sha512-I88TYZWc9XiYHRQ4/3c5rjjfgkjhLyW2luGIheGERbNQ6OY7yTybanSpDXZa8y7VUP9YmDcYa+eyq4ca7iLqWA==",
      "dev": true
    },
    "node_modules/electron-to-chromium": {
      "version": "1.5.33",
      "resolved": "https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.5.33.tgz",
      "integrity": "sha512-+cYTcFB1QqD4j4LegwLfpCNxifb6dDFUAwk6RsLusCwIaZI6or2f+q8rs5tTB2YC53HhOlIbEaqHMAAC8IOIwA==",
      "dev": true
    },
    "node_modules/emoji-regex": {
      "version": "9.2.2",
      "resolved": "https://registry.npmjs.org/emoji-regex/-/emoji-regex-9.2.2.tgz",
      "integrity": "sha512-L18DaJsXSUk2+42pv8mLs5jJT2hqFkFE4j21wOmgbUqsZ2hL72NsUU785g9RXgo3s0ZNgVl42TiHp3ZtOv/Vyg==",
      "dev": true
    },
    "node_modules/es-define-property": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.1.tgz",
      "integrity": "sha512-e3nRfgfUZ4rNGL232gUgX06QNyyez04KdjFrF+LTRoOXmrOgFKDg4BCdsjW8EnT69eqdYGmRpJwiPVYNrCaW3g==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/es-errors": {
      "version": "1.3.0",
      "resolved": "https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz",
      "integrity": "sha512-Zf5H2Kxt2xjTvbJvP2ZWLEICxA6j+hAmMzIlypy4xcBg1vKVnx89Wy0GbS+kf5cwCVFFzdCFh2XSCFNULS6csw==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/es-object-atoms": {
      "version": "1.1.2",
      "resolved": "https://registry.npmjs.org/es-object-atoms/-/es-object-atoms-1.1.2.tgz",
      "integrity": "sha512-HWcBoN6NileqtSydK2FqHbS/LoDd2pqrnQHLyJzBj4kOp/ky2MWMN694xOfkK8/SnUsW2DH7EfyVlydKCsm1Zw==",
      "license": "MIT",
      "dependencies": {
        "es-errors": "^1.3.0"
      },
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/es-set-tostringtag": {
      "version": "2.1.0",
      "resolved": "https://registry.npmjs.org/es-set-tostringtag/-/es-set-tostringtag-2.1.0.tgz",
      "integrity": "sha512-j6vWzfrGVfyXxge+O0x5sh6cvxAog0a/4Rdd2K36zCMV5eJ+/+tOAngRO8cODMNWbVRdVlmGZQL2YS3yR8bIUA==",
      "license": "MIT",
      "dependencies": {
        "es-errors": "^1.3.0",
        "get-intrinsic": "^1.2.6",
        "has-tostringtag": "^1.0.2",
        "hasown": "^2.0.2"
      },
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/esbuild": {
      "version": "0.21.5",
      "resolved": "https://registry.npmjs.org/esbuild/-/esbuild-0.21.5.tgz",
      "integrity": "sha512-mg3OPMV4hXywwpoDxu3Qda5xCKQi+vCTZq8S9J/EpkhB2HzKXq4SNFZE3+NK93JYxc8VMSep+lOUSC/RVKaBqw==",
      "dev": true,
      "hasInstallScript": true,
      "bin": {
        "esbuild": "bin/esbuild"
      },
      "engines": {
        "node": ">=12"
      },
      "optionalDependencies": {
        "@esbuild/aix-ppc64": "0.21.5",
        "@esbuild/android-arm": "0.21.5",
        "@esbuild/android-arm64": "0.21.5",
        "@esbuild/android-x64": "0.21.5",
        "@esbuild/darwin-arm64": "0.21.5",
        "@esbuild/darwin-x64": "0.21.5",
        "@esbuild/freebsd-arm64": "0.21.5",
        "@esbuild/freebsd-x64": "0.21.5",
        "@esbuild/linux-arm": "0.21.5",
        "@esbuild/linux-arm64": "0.21.5",
        "@esbuild/linux-ia32": "0.21.5",
        "@esbuild/linux-loong64": "0.21.5",
        "@esbuild/linux-mips64el": "0.21.5",
        "@esbuild/linux-ppc64": "0.21.5",
        "@esbuild/linux-riscv64": "0.21.5",
        "@esbuild/linux-s390x": "0.21.5",
        "@esbuild/linux-x64": "0.21.5",
        "@esbuild/netbsd-x64": "0.21.5",
        "@esbuild/openbsd-x64": "0.21.5",
        "@esbuild/sunos-x64": "0.21.5",
        "@esbuild/win32-arm64": "0.21.5",
        "@esbuild/win32-ia32": "0.21.5",
        "@esbuild/win32-x64": "0.21.5"
      }
    },
    "node_modules/escalade": {
      "version": "3.2.0",
      "resolved": "https://registry.npmjs.org/escalade/-/escalade-3.2.0.tgz",
      "integrity": "sha512-WUj2qlxaQtO4g6Pq5c29GTcWGDyd8itL8zTlipgECz3JesAiiOKotd8JU6otB3PACgG6xkJUyVhboMS+bje/jA==",
      "dev": true,
      "engines": {
        "node": ">=6"
      }
    },
    "node_modules/escape-string-regexp": {
      "version": "1.0.5",
      "resolved": "https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz",
      "integrity": "sha512-vbRorB5FUQWvla16U8R/qgaFIya2qGzwDrNmCZuYKrbdSUMG6I1ZCGQRefkRVhuOkIGVne7BQ35DSfo1qvJqFg==",
      "dev": true,
      "engines": {
        "node": ">=0.8.0"
      }
    },
    "node_modules/eslint": {
      "version": "9.12.0",
      "resolved": "https://registry.npmjs.org/eslint/-/eslint-9.12.0.tgz",
      "integrity": "sha512-UVIOlTEWxwIopRL1wgSQYdnVDcEvs2wyaO6DGo5mXqe3r16IoCNWkR29iHhyaP4cICWjbgbmFUGAhh0GJRuGZw==",
      "dev": true,
      "dependencies": {
        "@eslint-community/eslint-utils": "^4.2.0",
        "@eslint-community/regexpp": "^4.11.0",
        "@eslint/config-array": "^0.18.0",
        "@eslint/core": "^0.6.0",
        "@eslint/eslintrc": "^3.1.0",
        "@eslint/js": "9.12.0",
        "@eslint/plugin-kit": "^0.2.0",
        "@humanfs/node": "^0.16.5",
        "@humanwhocodes/module-importer": "^1.0.1",
        "@humanwhocodes/retry": "^0.3.1",
        "@types/estree": "^1.0.6",
        "@types/json-schema": "^7.0.15",
        "ajv": "^6.12.4",
        "chalk": "^4.0.0",
        "cross-spawn": "^7.0.2",
        "debug": "^4.3.2",
        "escape-string-regexp": "^4.0.0",
        "eslint-scope": "^8.1.0",
        "eslint-visitor-keys": "^4.1.0",
        "espree": "^10.2.0",
        "esquery": "^1.5.0",
        "esutils": "^2.0.2",
        "fast-deep-equal": "^3.1.3",
        "file-entry-cache": "^8.0.0",
        "find-up": "^5.0.0",
        "glob-parent": "^6.0.2",
        "ignore": "^5.2.0",
        "imurmurhash": "^0.1.4",
        "is-glob": "^4.0.0",
        "json-stable-stringify-without-jsonify": "^1.0.1",
        "lodash.merge": "^4.6.2",
        "minimatch": "^3.1.2",
        "natural-compare": "^1.4.0",
        "optionator": "^0.9.3",
        "text-table": "^0.2.0"
      },
      "bin": {
        "eslint": "bin/eslint.js"
      },
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      },
      "funding": {
        "url": "https://eslint.org/donate"
      },
      "peerDependencies": {
        "jiti": "*"
      },
      "peerDependenciesMeta": {
        "jiti": {
          "optional": true
        }
      }
    },
    "node_modules/eslint-plugin-react-hooks": {
      "version": "5.1.0-rc-fb9a90fa48-20240614",
      "resolved": "https://registry.npmjs.org/eslint-plugin-react-hooks/-/eslint-plugin-react-hooks-5.1.0-rc-fb9a90fa48-20240614.tgz",
      "integrity": "sha512-xsiRwaDNF5wWNC4ZHLut+x/YcAxksUd9Rizt7LaEn3bV8VyYRpXnRJQlLOfYaVy9esk4DFP4zPPnoNVjq5Gc0w==",
      "dev": true,
      "engines": {
        "node": ">=10"
      },
      "peerDependencies": {
        "eslint": "^3.0.0 || ^4.0.0 || ^5.0.0 || ^6.0.0 || ^7.0.0 || ^8.0.0-0 || ^9.0.0"
      }
    },
    "node_modules/eslint-plugin-react-refresh": {
      "version": "0.4.12",
      "resolved": "https://registry.npmjs.org/eslint-plugin-react-refresh/-/eslint-plugin-react-refresh-0.4.12.tgz",
      "integrity": "sha512-9neVjoGv20FwYtCP6CB1dzR1vr57ZDNOXst21wd2xJ/cTlM2xLq0GWVlSNTdMn/4BtP6cHYBMCSp1wFBJ9jBsg==",
      "dev": true,
      "peerDependencies": {
        "eslint": ">=7"
      }
    },
    "node_modules/eslint-scope": {
      "version": "8.1.0",
      "resolved": "https://registry.npmjs.org/eslint-scope/-/eslint-scope-8.1.0.tgz",
      "integrity": "sha512-14dSvlhaVhKKsa9Fx1l8A17s7ah7Ef7wCakJ10LYk6+GYmP9yDti2oq2SEwcyndt6knfcZyhyxwY3i9yL78EQw==",
      "dev": true,
      "dependencies": {
        "esrecurse": "^4.3.0",
        "estraverse": "^5.2.0"
      },
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      },
      "funding": {
        "url": "https://opencollective.com/eslint"
      }
    },
    "node_modules/eslint-visitor-keys": {
      "version": "4.1.0",
      "resolved": "https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-4.1.0.tgz",
      "integrity": "sha512-Q7lok0mqMUSf5a/AdAZkA5a/gHcO6snwQClVNNvFKCAVlxXucdU8pKydU5ZVZjBx5xr37vGbFFWtLQYreLzrZg==",
      "dev": true,
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      },
      "funding": {
        "url": "https://opencollective.com/eslint"
      }
    },
    "node_modules/eslint/node_modules/ansi-styles": {
      "version": "4.3.0",
      "resolved": "https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz",
      "integrity": "sha512-zbB9rCJAT1rbjiVDb2hqKFHNYLxgtk8NURxZ3IZwD3F6NtxbXZQCnnSi1Lkx+IDohdPlFp222wVALIheZJQSEg==",
      "dev": true,
      "dependencies": {
        "color-convert": "^2.0.1"
      },
      "engines": {
        "node": ">=8"
      },
      "funding": {
        "url": "https://github.com/chalk/ansi-styles?sponsor=1"
      }
    },
    "node_modules/eslint/node_modules/chalk": {
      "version": "4.1.2",
      "resolved": "https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz",
      "integrity": "sha512-oKnbhFyRIXpUuez8iBMmyEa4nbj4IOQyuhc/wy9kY7/WVPcwIO9VA668Pu8RkO7+0G76SLROeyw9CpQ061i4mA==",
      "dev": true,
      "dependencies": {
        "ansi-styles": "^4.1.0",
        "supports-color": "^7.1.0"
      },
      "engines": {
        "node": ">=10"
      },
      "funding": {
        "url": "https://github.com/chalk/chalk?sponsor=1"
      }
    },
    "node_modules/eslint/node_modules/color-convert": {
      "version": "2.0.1",
      "resolved": "https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz",
      "integrity": "sha512-RRECPsj7iu/xb5oKYcsFHSppFNnsj/52OVTRKb4zP5onXwVF3zVmmToNcOfGC+CRDpfK/U584fMg38ZHCaElKQ==",
      "dev": true,
      "dependencies": {
        "color-name": "~1.1.4"
      },
      "engines": {
        "node": ">=7.0.0"
      }
    },
    "node_modules/eslint/node_modules/color-name": {
      "version": "1.1.4",
      "resolved": "https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz",
      "integrity": "sha512-dOy+3AuW3a2wNbZHIuMZpTcgjGuLU/uBL/ubcZF9OXbDo8ff4O8yVp5Bf0efS8uEoYo5q4Fx7dY9OgQGXgAsQA==",
      "dev": true
    },
    "node_modules/eslint/node_modules/escape-string-regexp": {
      "version": "4.0.0",
      "resolved": "https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz",
      "integrity": "sha512-TtpcNJ3XAzx3Gq8sWRzJaVajRs0uVxA2YAkdb1jm2YkPz4G6egUFAyA3n5vtEIZefPk5Wa4UXbKuS5fKkJWdgA==",
      "dev": true,
      "engines": {
        "node": ">=10"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/eslint/node_modules/has-flag": {
      "version": "4.0.0",
      "resolved": "https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz",
      "integrity": "sha512-EykJT/Q1KjTWctppgIAgfSO0tKVuZUjhgMr17kqTumMl6Afv3EISleU7qZUzoXDFTAHTDC4NOoG/ZxU3EvlMPQ==",
      "dev": true,
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/eslint/node_modules/supports-color": {
      "version": "7.2.0",
      "resolved": "https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz",
      "integrity": "sha512-qpCAvRl9stuOHveKsn7HncJRvv501qIacKzQlO/+Lwxc9+0q2wLyv4Dfvt80/DPn2pqOBsJdDiogXGR9+OvwRw==",
      "dev": true,
      "dependencies": {
        "has-flag": "^4.0.0"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/espree": {
      "version": "10.2.0",
      "resolved": "https://registry.npmjs.org/espree/-/espree-10.2.0.tgz",
      "integrity": "sha512-upbkBJbckcCNBDBDXEbuhjbP68n+scUd3k/U2EkyM9nw+I/jPiL4cLF/Al06CF96wRltFda16sxDFrxsI1v0/g==",
      "dev": true,
      "dependencies": {
        "acorn": "^8.12.0",
        "acorn-jsx": "^5.3.2",
        "eslint-visitor-keys": "^4.1.0"
      },
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      },
      "funding": {
        "url": "https://opencollective.com/eslint"
      }
    },
    "node_modules/esquery": {
      "version": "1.6.0",
      "resolved": "https://registry.npmjs.org/esquery/-/esquery-1.6.0.tgz",
      "integrity": "sha512-ca9pw9fomFcKPvFLXhBKUK90ZvGibiGOvRJNbjljY7s7uq/5YO4BOzcYtJqExdx99rF6aAcnRxHmcUHcz6sQsg==",
      "dev": true,
      "dependencies": {
        "estraverse": "^5.1.0"
      },
      "engines": {
        "node": ">=0.10"
      }
    },
    "node_modules/esrecurse": {
      "version": "4.3.0",
      "resolved": "https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz",
      "integrity": "sha512-KmfKL3b6G+RXvP8N1vr3Tq1kL/oCFgn2NYXEtqP8/L3pKapUA4G8cFVaoF3SU323CD4XypR/ffioHmkti6/Tag==",
      "dev": true,
      "dependencies": {
        "estraverse": "^5.2.0"
      },
      "engines": {
        "node": ">=4.0"
      }
    },
    "node_modules/estraverse": {
      "version": "5.3.0",
      "resolved": "https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz",
      "integrity": "sha512-MMdARuVEQziNTeJD8DgMqmhwR11BRQ/cBP+pLtYdSTnf3MIO8fFeiINEbX36ZdNlfU/7A9f3gUw49B3oQsvwBA==",
      "dev": true,
      "engines": {
        "node": ">=4.0"
      }
    },
    "node_modules/esutils": {
      "version": "2.0.3",
      "resolved": "https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz",
      "integrity": "sha512-kVscqXk4OCp68SZ0dkgEKVi6/8ij300KBWTJq32P/dYeWTSwK41WyTxalN1eRmA5Z9UU/LX9D7FWSmV9SAYx6g==",
      "dev": true,
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/fast-deep-equal": {
      "version": "3.1.3",
      "resolved": "https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz",
      "integrity": "sha512-f3qQ9oQy9j2AhBe/H9VC91wLmKBCCU/gDOnKNAYG5hswO7BLKj09Hc5HYNz9cGI++xlpDCIgDaitVs03ATR84Q==",
      "dev": true
    },
    "node_modules/fast-glob": {
      "version": "3.3.2",
      "resolved": "https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.2.tgz",
      "integrity": "sha512-oX2ruAFQwf/Orj8m737Y5adxDQO0LAB7/S5MnxCdTNDd4p6BsyIVsv9JQsATbTSq8KHRpLwIHbVlUNatxd+1Ow==",
      "dev": true,
      "dependencies": {
        "@nodelib/fs.stat": "^2.0.2",
        "@nodelib/fs.walk": "^1.2.3",
        "glob-parent": "^5.1.2",
        "merge2": "^1.3.0",
        "micromatch": "^4.0.4"
      },
      "engines": {
        "node": ">=8.6.0"
      }
    },
    "node_modules/fast-glob/node_modules/glob-parent": {
      "version": "5.1.2",
      "resolved": "https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz",
      "integrity": "sha512-AOIgSQCepiJYwP3ARnGx+5VnTu2HBYdzbGP45eLw1vr3zB3vZLeyed1sC9hnbcOc9/SrMyM5RPQrkGz4aS9Zow==",
      "dev": true,
      "dependencies": {
        "is-glob": "^4.0.1"
      },
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/fast-json-stable-stringify": {
      "version": "2.1.0",
      "resolved": "https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz",
      "integrity": "sha512-lhd/wF+Lk98HZoTCtlVraHtfh5XYijIjalXck7saUtuanSDyLMxnHhSXEDJqHxD7msR8D0uCmqlkwjCV8xvwHw==",
      "dev": true
    },
    "node_modules/fast-levenshtein": {
      "version": "2.0.6",
      "resolved": "https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz",
      "integrity": "sha512-DCXu6Ifhqcks7TZKY3Hxp3y6qphY5SJZmrWMDrKcERSOXWQdMhU9Ig/PYrzyw/ul9jOIyh0N4M0tbC5hodg8dw==",
      "dev": true
    },
    "node_modules/fastq": {
      "version": "1.17.1",
      "resolved": "https://registry.npmjs.org/fastq/-/fastq-1.17.1.tgz",
      "integrity": "sha512-sRVD3lWVIXWg6By68ZN7vho9a1pQcN/WBFaAAsDDFzlJjvoGx0P8z7V1t72grFJfJhu3YPZBuu25f7Kaw2jN1w==",
      "dev": true,
      "dependencies": {
        "reusify": "^1.0.4"
      }
    },
    "node_modules/file-entry-cache": {
      "version": "8.0.0",
      "resolved": "https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-8.0.0.tgz",
      "integrity": "sha512-XXTUwCvisa5oacNGRP9SfNtYBNAMi+RPwBFmblZEF7N7swHYQS6/Zfk7SRwx4D5j3CH211YNRco1DEMNVfZCnQ==",
      "dev": true,
      "dependencies": {
        "flat-cache": "^4.0.0"
      },
      "engines": {
        "node": ">=16.0.0"
      }
    },
    "node_modules/fill-range": {
      "version": "7.1.1",
      "resolved": "https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz",
      "integrity": "sha512-YsGpe3WHLK8ZYi4tWDg2Jy3ebRz2rXowDxnld4bkQB00cc/1Zw9AWnC0i9ztDJitivtQvaI9KaLyKrc+hBW0yg==",
      "dev": true,
      "dependencies": {
        "to-regex-range": "^5.0.1"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/find-up": {
      "version": "5.0.0",
      "resolved": "https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz",
      "integrity": "sha512-78/PXT1wlLLDgTzDs7sjq9hzz0vXD+zn+7wypEe4fXQxCmdmqfGsEPQxmiCSQI3ajFV91bVSsvNtrJRiW6nGng==",
      "dev": true,
      "dependencies": {
        "locate-path": "^6.0.0",
        "path-exists": "^4.0.0"
      },
      "engines": {
        "node": ">=10"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/flat-cache": {
      "version": "4.0.1",
      "resolved": "https://registry.npmjs.org/flat-cache/-/flat-cache-4.0.1.tgz",
      "integrity": "sha512-f7ccFPK3SXFHpx15UIGyRJ/FJQctuKZ0zVuN3frBo4HnK3cay9VEW0R6yPYFHC0AgqhukPzKjq22t5DmAyqGyw==",
      "dev": true,
      "dependencies": {
        "flatted": "^3.2.9",
        "keyv": "^4.5.4"
      },
      "engines": {
        "node": ">=16"
      }
    },
    "node_modules/flatted": {
      "version": "3.3.1",
      "resolved": "https://registry.npmjs.org/flatted/-/flatted-3.3.1.tgz",
      "integrity": "sha512-X8cqMLLie7KsNUDSdzeN8FYK9rEt4Dt67OsG/DNGnYTSDBG4uFAJFBnUeiV+zCVAvwFy56IjM9sH51jVaEhNxw==",
      "dev": true
    },
    "node_modules/follow-redirects": {
      "version": "1.16.0",
      "resolved": "https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.16.0.tgz",
      "integrity": "sha512-y5rN/uOsadFT/JfYwhxRS5R7Qce+g3zG97+JrtFZlC9klX/W5hD7iiLzScI4nZqUS7DNUdhPgw4xI8W2LuXlUw==",
      "funding": [
        {
          "type": "individual",
          "url": "https://github.com/sponsors/RubenVerborgh"
        }
      ],
      "license": "MIT",
      "engines": {
        "node": ">=4.0"
      },
      "peerDependenciesMeta": {
        "debug": {
          "optional": true
        }
      }
    },
    "node_modules/foreground-child": {
      "version": "3.3.0",
      "resolved": "https://registry.npmjs.org/foreground-child/-/foreground-child-3.3.0.tgz",
      "integrity": "sha512-Ld2g8rrAyMYFXBhEqMz8ZAHBi4J4uS1i/CxGMDnjyFWddMXLVcDp051DZfu+t7+ab7Wv6SMqpWmyFIj5UbfFvg==",
      "dev": true,
      "dependencies": {
        "cross-spawn": "^7.0.0",
        "signal-exit": "^4.0.1"
      },
      "engines": {
        "node": ">=14"
      },
      "funding": {
        "url": "https://github.com/sponsors/isaacs"
      }
    },
    "node_modules/form-data": {
      "version": "4.0.5",
      "resolved": "https://registry.npmjs.org/form-data/-/form-data-4.0.5.tgz",
      "integrity": "sha512-8RipRLol37bNs2bhoV67fiTEvdTrbMUYcFTiy3+wuuOnUog2QBHCZWXDRijWQfAkhBj2Uf5UnVaiWwA5vdd82w==",
      "license": "MIT",
      "dependencies": {
        "asynckit": "^0.4.0",
        "combined-stream": "^1.0.8",
        "es-set-tostringtag": "^2.1.0",
        "hasown": "^2.0.2",
        "mime-types": "^2.1.12"
      },
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/fraction.js": {
      "version": "4.3.7",
      "resolved": "https://registry.npmjs.org/fraction.js/-/fraction.js-4.3.7.tgz",
      "integrity": "sha512-ZsDfxO51wGAXREY55a7la9LScWpwv9RxIrYABrlvOFBlH/ShPnrtsXeuUIfXKKOVicNxQ+o8JTbJvjS4M89yew==",
      "dev": true,
      "engines": {
        "node": "*"
      },
      "funding": {
        "type": "patreon",
        "url": "https://github.com/sponsors/rawify"
      }
    },
    "node_modules/fsevents": {
      "version": "2.3.3",
      "resolved": "https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz",
      "integrity": "sha512-5xoDfX+fL7faATnagmWPpbFtwh/R77WmMMqqHGS65C3vvB0YHrgF+B1YmZ3441tMj5n63k0212XNoJwzlhffQw==",
      "dev": true,
      "hasInstallScript": true,
      "optional": true,
      "os": [
        "darwin"
      ],
      "engines": {
        "node": "^8.16.0 || ^10.6.0 || >=11.0.0"
      }
    },
    "node_modules/function-bind": {
      "version": "1.1.2",
      "resolved": "https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz",
      "integrity": "sha512-7XHNxH7qX9xG5mIwxkhumTox/MIRNcOgDrxWsMt2pAr23WHp6MrRlN7FBSFpCpr+oVO0F744iUgR82nJMfG2SA==",
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/gensync": {
      "version": "1.0.0-beta.2",
      "resolved": "https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz",
      "integrity": "sha512-3hN7NaskYvMDLQY55gnW3NQ+mesEAepTqlg+VEbj7zzqEMBVNhzcGYYeqFo/TlYz6eQiFcp1HcsCZO+nGgS8zg==",
      "dev": true,
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/get-intrinsic": {
      "version": "1.3.0",
      "resolved": "https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.3.0.tgz",
      "integrity": "sha512-9fSjSaos/fRIVIp+xSJlE6lfwhES7LNtKaCBIamHsjr2na1BiABJPo0mOjjz8GJDURarmCPGqaiVg5mfjb98CQ==",
      "license": "MIT",
      "dependencies": {
        "call-bind-apply-helpers": "^1.0.2",
        "es-define-property": "^1.0.1",
        "es-errors": "^1.3.0",
        "es-object-atoms": "^1.1.1",
        "function-bind": "^1.1.2",
        "get-proto": "^1.0.1",
        "gopd": "^1.2.0",
        "has-symbols": "^1.1.0",
        "hasown": "^2.0.2",
        "math-intrinsics": "^1.1.0"
      },
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/get-proto": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/get-proto/-/get-proto-1.0.1.tgz",
      "integrity": "sha512-sTSfBjoXBp89JvIKIefqw7U2CCebsc74kiY6awiGogKtoSGbgjYE/G/+l9sF3MWFPNc9IcoOC4ODfKHfxFmp0g==",
      "license": "MIT",
      "dependencies": {
        "dunder-proto": "^1.0.1",
        "es-object-atoms": "^1.0.0"
      },
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/glob": {
      "version": "10.4.5",
      "resolved": "https://registry.npmjs.org/glob/-/glob-10.4.5.tgz",
      "integrity": "sha512-7Bv8RF0k6xjo7d4A/PxYLbUCfb6c+Vpd2/mB2yRDlew7Jb5hEXiCD9ibfO7wpk8i4sevK6DFny9h7EYbM3/sHg==",
      "dev": true,
      "dependencies": {
        "foreground-child": "^3.1.0",
        "jackspeak": "^3.1.2",
        "minimatch": "^9.0.4",
        "minipass": "^7.1.2",
        "package-json-from-dist": "^1.0.0",
        "path-scurry": "^1.11.1"
      },
      "bin": {
        "glob": "dist/esm/bin.mjs"
      },
      "funding": {
        "url": "https://github.com/sponsors/isaacs"
      }
    },
    "node_modules/glob-parent": {
      "version": "6.0.2",
      "resolved": "https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz",
      "integrity": "sha512-XxwI8EOhVQgWp6iDL+3b0r86f4d6AX6zSU55HfB4ydCEuXLXc5FcYeOu+nnGftS4TEju/11rt4KJPTMgbfmv4A==",
      "dev": true,
      "dependencies": {
        "is-glob": "^4.0.3"
      },
      "engines": {
        "node": ">=10.13.0"
      }
    },
    "node_modules/glob/node_modules/brace-expansion": {
      "version": "2.0.1",
      "resolved": "https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz",
      "integrity": "sha512-XnAIvQ8eM+kC6aULx6wuQiwVsnzsi9d3WxzV3FpWTGA19F621kwdbsAcFKXgKUHZWsy+mY6iL1sHTxWEFCytDA==",
      "dev": true,
      "dependencies": {
        "balanced-match": "^1.0.0"
      }
    },
    "node_modules/glob/node_modules/minimatch": {
      "version": "9.0.5",
      "resolved": "https://registry.npmjs.org/minimatch/-/minimatch-9.0.5.tgz",
      "integrity": "sha512-G6T0ZX48xgozx7587koeX9Ys2NYy6Gmv//P89sEte9V9whIapMNF4idKxnW2QtCcLiTWlb/wfCabAtAFWhhBow==",
      "dev": true,
      "dependencies": {
        "brace-expansion": "^2.0.1"
      },
      "engines": {
        "node": ">=16 || 14 >=14.17"
      },
      "funding": {
        "url": "https://github.com/sponsors/isaacs"
      }
    },
    "node_modules/globals": {
      "version": "15.11.0",
      "resolved": "https://registry.npmjs.org/globals/-/globals-15.11.0.tgz",
      "integrity": "sha512-yeyNSjdbyVaWurlwCpcA6XNBrHTMIeDdj0/hnvX/OLJ9ekOXYbLsLinH/MucQyGvNnXhidTdNhTtJaffL2sMfw==",
      "dev": true,
      "engines": {
        "node": ">=18"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/gopd": {
      "version": "1.2.0",
      "resolved": "https://registry.npmjs.org/gopd/-/gopd-1.2.0.tgz",
      "integrity": "sha512-ZUKRh6/kUFoAiTAtTYPZJ3hw9wNxx+BIBOijnlG9PnrJsCcSjs1wyyD6vJpaYtgnzDrKYRSqf3OO6Rfa93xsRg==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/graphemer": {
      "version": "1.4.0",
      "resolved": "https://registry.npmjs.org/graphemer/-/graphemer-1.4.0.tgz",
      "integrity": "sha512-EtKwoO6kxCL9WO5xipiHTZlSzBm7WLT627TqC/uVRd0HKmq8NXyebnNYxDoBi7wt8eTWrUrKXCOVaFq9x1kgag==",
      "dev": true
    },
    "node_modules/has-flag": {
      "version": "3.0.0",
      "resolved": "https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz",
      "integrity": "sha512-sKJf1+ceQBr4SMkvQnBDNDtf4TXpVhVGateu0t918bl30FnbE2m4vNLX+VWe/dpjlb+HugGYzW7uQXH98HPEYw==",
      "dev": true,
      "engines": {
        "node": ">=4"
      }
    },
    "node_modules/has-symbols": {
      "version": "1.1.0",
      "resolved": "https://registry.npmjs.org/has-symbols/-/has-symbols-1.1.0.tgz",
      "integrity": "sha512-1cDNdwJ2Jaohmb3sg4OmKaMBwuC48sYni5HUw2DvsC8LjGTLK9h+eb1X6RyuOHe4hT0ULCW68iomhjUoKUqlPQ==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/has-tostringtag": {
      "version": "1.0.2",
      "resolved": "https://registry.npmjs.org/has-tostringtag/-/has-tostringtag-1.0.2.tgz",
      "integrity": "sha512-NqADB8VjPFLM2V0VvHUewwwsw0ZWBaIdgo+ieHtK3hasLz4qeCRjYcqfB6AQrBggRKppKF8L52/VqdVsO47Dlw==",
      "license": "MIT",
      "dependencies": {
        "has-symbols": "^1.0.3"
      },
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/hasown": {
      "version": "2.0.2",
      "resolved": "https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz",
      "integrity": "sha512-0hJU9SCPvmMzIBdZFqNPXWa6dqh7WdH0cII9y+CyS8rG3nL48Bclra9HmKhVVUHyPWNH5Y7xDwAB7bfgSjkUMQ==",
      "dependencies": {
        "function-bind": "^1.1.2"
      },
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/https-proxy-agent": {
      "version": "5.0.1",
      "resolved": "https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz",
      "integrity": "sha512-dFcAjpTQFgoLMzC2VwU+C/CbS7uRL0lWmxDITmqm7C+7F0Odmj6s9l6alZc6AELXhrnggM2CeWSXHGOdX2YtwA==",
      "license": "MIT",
      "dependencies": {
        "agent-base": "6",
        "debug": "4"
      },
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/ignore": {
      "version": "5.3.2",
      "resolved": "https://registry.npmjs.org/ignore/-/ignore-5.3.2.tgz",
      "integrity": "sha512-hsBTNUqQTDwkWtcdYI2i06Y/nUBEsNEDJKjWdigLvegy8kDuJAS8uRlpkkcQpyEXL0Z/pjDy5HBmMjRCJ2gq+g==",
      "dev": true,
      "engines": {
        "node": ">= 4"
      }
    },
    "node_modules/import-fresh": {
      "version": "3.3.0",
      "resolved": "https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz",
      "integrity": "sha512-veYYhQa+D1QBKznvhUHxb8faxlrwUnxseDAbAp457E0wLNio2bOSKnjYDhMj+YiAq61xrMGhQk9iXVk5FzgQMw==",
      "dev": true,
      "dependencies": {
        "parent-module": "^1.0.0",
        "resolve-from": "^4.0.0"
      },
      "engines": {
        "node": ">=6"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/imurmurhash": {
      "version": "0.1.4",
      "resolved": "https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz",
      "integrity": "sha512-JmXMZ6wuvDmLiHEml9ykzqO6lwFbof0GG4IkcGaENdCRDDmMVnny7s5HsIgHCbaq0w2MyPhDqkhTUgS2LU2PHA==",
      "dev": true,
      "engines": {
        "node": ">=0.8.19"
      }
    },
    "node_modules/is-binary-path": {
      "version": "2.1.0",
      "resolved": "https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz",
      "integrity": "sha512-ZMERYes6pDydyuGidse7OsHxtbI7WVeUEozgR/g7rd0xUimYNlvZRE/K2MgZTjWy725IfelLeVcEM97mmtRGXw==",
      "dev": true,
      "dependencies": {
        "binary-extensions": "^2.0.0"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/is-core-module": {
      "version": "2.15.1",
      "resolved": "https://registry.npmjs.org/is-core-module/-/is-core-module-2.15.1.tgz",
      "integrity": "sha512-z0vtXSwucUJtANQWldhbtbt7BnL0vxiFjIdDLAatwhDYty2bad6s+rijD6Ri4YuYJubLzIJLUidCh09e1djEVQ==",
      "dev": true,
      "dependencies": {
        "hasown": "^2.0.2"
      },
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/is-extglob": {
      "version": "2.1.1",
      "resolved": "https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz",
      "integrity": "sha512-SbKbANkN603Vi4jEZv49LeVJMn4yGwsbzZworEoyEiutsN3nJYdbO36zfhGJ6QEDpOZIFkDtnq5JRxmvl3jsoQ==",
      "dev": true,
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/is-fullwidth-code-point": {
      "version": "3.0.0",
      "resolved": "https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz",
      "integrity": "sha512-zymm5+u+sCsSWyD9qNaejV3DFvhCKclKdizYaJUuHA83RLjb7nSuGnddCHGv0hk+KY7BMAlsWeK4Ueg6EV6XQg==",
      "dev": true,
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/is-glob": {
      "version": "4.0.3",
      "resolved": "https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz",
      "integrity": "sha512-xelSayHH36ZgE7ZWhli7pW34hNbNl8Ojv5KVmkJD4hBdD3th8Tfk9vYasLM+mXWOZhFkgZfxhLSnrwRr4elSSg==",
      "dev": true,
      "dependencies": {
        "is-extglob": "^2.1.1"
      },
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/is-number": {
      "version": "7.0.0",
      "resolved": "https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz",
      "integrity": "sha512-41Cifkg6e8TylSpdtTpeLVMqvSBEVzTttHvERD741+pnZ8ANv0004MRL43QKPDlK9cGvNp6NZWZUBlbGXYxxng==",
      "dev": true,
      "engines": {
        "node": ">=0.12.0"
      }
    },
    "node_modules/isexe": {
      "version": "2.0.0",
      "resolved": "https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz",
      "integrity": "sha512-RHxMLp9lnKHGHRng9QFhRCMbYAcVpn69smSGcq3f36xjgVVWThj4qqLbTLlq7Ssj8B+fIQ1EuCEGI2lKsyQeIw==",
      "dev": true
    },
    "node_modules/jackspeak": {
      "version": "3.4.3",
      "resolved": "https://registry.npmjs.org/jackspeak/-/jackspeak-3.4.3.tgz",
      "integrity": "sha512-OGlZQpz2yfahA/Rd1Y8Cd9SIEsqvXkLVoSw/cgwhnhFMDbsQFeZYoJJ7bIZBS9BcamUW96asq/npPWugM+RQBw==",
      "dev": true,
      "dependencies": {
        "@isaacs/cliui": "^8.0.2"
      },
      "funding": {
        "url": "https://github.com/sponsors/isaacs"
      },
      "optionalDependencies": {
        "@pkgjs/parseargs": "^0.11.0"
      }
    },
    "node_modules/jiti": {
      "version": "1.21.6",
      "resolved": "https://registry.npmjs.org/jiti/-/jiti-1.21.6.tgz",
      "integrity": "sha512-2yTgeWTWzMWkHu6Jp9NKgePDaYHbntiwvYuuJLbbN9vl7DC9DvXKOB2BC3ZZ92D3cvV/aflH0osDfwpHepQ53w==",
      "dev": true,
      "bin": {
        "jiti": "bin/jiti.js"
      }
    },
    "node_modules/js-tokens": {
      "version": "4.0.0",
      "resolved": "https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz",
      "integrity": "sha512-RdJUflcE3cUzKiMqQgsCu06FPu9UdIJO0beYbPhHN4k6apgJtifcoCtT9bcxOpYBtpD2kCM6Sbzg4CausW/PKQ=="
    },
    "node_modules/js-yaml": {
      "version": "4.1.0",
      "resolved": "https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz",
      "integrity": "sha512-wpxZs9NoxZaJESJGIZTyDEaYpl0FKSA+FB9aJiyemKhMwkxQg63h4T1KJgUGHpTqPDNRcmmYLugrRjJlBtWvRA==",
      "dev": true,
      "dependencies": {
        "argparse": "^2.0.1"
      },
      "bin": {
        "js-yaml": "bin/js-yaml.js"
      }
    },
    "node_modules/jsesc": {
      "version": "3.0.2",
      "resolved": "https://registry.npmjs.org/jsesc/-/jsesc-3.0.2.tgz",
      "integrity": "sha512-xKqzzWXDttJuOcawBt4KnKHHIf5oQ/Cxax+0PWFG+DFDgHNAdi+TXECADI+RYiFUMmx8792xsMbbgXj4CwnP4g==",
      "dev": true,
      "bin": {
        "jsesc": "bin/jsesc"
      },
      "engines": {
        "node": ">=6"
      }
    },
    "node_modules/json-buffer": {
      "version": "3.0.1",
      "resolved": "https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz",
      "integrity": "sha512-4bV5BfR2mqfQTJm+V5tPPdf+ZpuhiIvTuAB5g8kcrXOZpTT/QwwVRWBywX1ozr6lEuPdbHxwaJlm9G6mI2sfSQ==",
      "dev": true
    },
    "node_modules/json-schema-traverse": {
      "version": "0.4.1",
      "resolved": "https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz",
      "integrity": "sha512-xbbCH5dCYU5T8LcEhhuh7HJ88HXuW3qsI3Y0zOZFKfZEHcpWiHU/Jxzk629Brsab/mMiHQti9wMP+845RPe3Vg==",
      "dev": true
    },
    "node_modules/json-stable-stringify-without-jsonify": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz",
      "integrity": "sha512-Bdboy+l7tA3OGW6FjyFHWkP5LuByj1Tk33Ljyq0axyzdk9//JSi2u3fP1QSmd1KNwq6VOKYGlAu87CisVir6Pw==",
      "dev": true
    },
    "node_modules/json5": {
      "version": "2.2.3",
      "resolved": "https://registry.npmjs.org/json5/-/json5-2.2.3.tgz",
      "integrity": "sha512-XmOWe7eyHYH14cLdVPoyg+GOH3rYX++KpzrylJwSW98t3Nk+U8XOl8FWKOgwtzdb8lXGf6zYwDUzeHMWfxasyg==",
      "dev": true,
      "bin": {
        "json5": "lib/cli.js"
      },
      "engines": {
        "node": ">=6"
      }
    },
    "node_modules/keyv": {
      "version": "4.5.4",
      "resolved": "https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz",
      "integrity": "sha512-oxVHkHR/EJf2CNXnWxRLW6mg7JyCCUcG0DtEGmL2ctUo1PNTin1PUil+r/+4r5MpVgC/fn1kjsx7mjSujKqIpw==",
      "dev": true,
      "dependencies": {
        "json-buffer": "3.0.1"
      }
    },
    "node_modules/leaflet": {
      "version": "1.9.4",
      "resolved": "https://registry.npmjs.org/leaflet/-/leaflet-1.9.4.tgz",
      "integrity": "sha512-nxS1ynzJOmOlHp+iL3FyWqK89GtNL8U8rvlMOsQdTTssxZwCXh8N2NB3GDQOL+YR3XnWyZAxwQixURb+FA74PA==",
      "license": "BSD-2-Clause"
    },
    "node_modules/levn": {
      "version": "0.4.1",
      "resolved": "https://registry.npmjs.org/levn/-/levn-0.4.1.tgz",
      "integrity": "sha512-+bT2uH4E5LGE7h/n3evcS/sQlJXCpIp6ym8OWJ5eV6+67Dsql/LaaT7qJBAt2rzfoa/5QBGBhxDix1dMt2kQKQ==",
      "dev": true,
      "dependencies": {
        "prelude-ls": "^1.2.1",
        "type-check": "~0.4.0"
      },
      "engines": {
        "node": ">= 0.8.0"
      }
    },
    "node_modules/lilconfig": {
      "version": "3.1.3",
      "resolved": "https://registry.npmjs.org/lilconfig/-/lilconfig-3.1.3.tgz",
      "integrity": "sha512-/vlFKAoH5Cgt3Ie+JLhRbwOsCQePABiU3tJ1egGvyQ+33R/vcwM2Zl2QR/LzjsBeItPt3oSVXapn+m4nQDvpzw==",
      "dev": true,
      "engines": {
        "node": ">=14"
      },
      "funding": {
        "url": "https://github.com/sponsors/antonk52"
      }
    },
    "node_modules/lines-and-columns": {
      "version": "1.2.4",
      "resolved": "https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz",
      "integrity": "sha512-7ylylesZQ/PV29jhEDl3Ufjo6ZX7gCqJr5F7PKrqc93v7fzSymt1BpwEU8nAUXs8qzzvqhbjhK5QZg6Mt/HkBg==",
      "dev": true
    },
    "node_modules/locate-path": {
      "version": "6.0.0",
      "resolved": "https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz",
      "integrity": "sha512-iPZK6eYjbxRu3uB4/WZ3EsEIMJFMqAoopl3R+zuq0UjcAm/MO6KCweDgPfP3elTztoKP3KtnVHxTn2NHBSDVUw==",
      "dev": true,
      "dependencies": {
        "p-locate": "^5.0.0"
      },
      "engines": {
        "node": ">=10"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/lodash.merge": {
      "version": "4.6.2",
      "resolved": "https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz",
      "integrity": "sha512-0KpjqXRVvrYyCsX1swR/XTK0va6VQkQM6MNo7PqW77ByjAhoARA8EfrP1N4+KlKj8YS0ZUCtRT/YUuhyYDujIQ==",
      "dev": true
    },
    "node_modules/loose-envify": {
      "version": "1.4.0",
      "resolved": "https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz",
      "integrity": "sha512-lyuxPGr/Wfhrlem2CL/UcnUc1zcqKAImBDzukY7Y5F/yQiNdko6+fRLevlw1HgMySw7f611UIY408EtxRSoK3Q==",
      "dependencies": {
        "js-tokens": "^3.0.0 || ^4.0.0"
      },
      "bin": {
        "loose-envify": "cli.js"
      }
    },
    "node_modules/lru-cache": {
      "version": "5.1.1",
      "resolved": "https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz",
      "integrity": "sha512-KpNARQA3Iwv+jTA0utUVVbrh+Jlrr1Fv0e56GGzAFOXN7dk/FviaDW8LHmK52DlcH4WP2n6gI8vN1aesBFgo9w==",
      "dev": true,
      "dependencies": {
        "yallist": "^3.0.2"
      }
    },
    "node_modules/lucide-react": {
      "version": "0.344.0",
      "resolved": "https://registry.npmjs.org/lucide-react/-/lucide-react-0.344.0.tgz",
      "integrity": "sha512-6YyBnn91GB45VuVT96bYCOKElbJzUHqp65vX8cDcu55MQL9T969v4dhGClpljamuI/+KMO9P6w9Acq1CVQGvIQ==",
      "peerDependencies": {
        "react": "^16.5.1 || ^17.0.0 || ^18.0.0"
      }
    },
    "node_modules/math-intrinsics": {
      "version": "1.1.0",
      "resolved": "https://registry.npmjs.org/math-intrinsics/-/math-intrinsics-1.1.0.tgz",
      "integrity": "sha512-/IXtbwEk5HTPyEwyKX6hGkYXxM9nbj64B+ilVJnC/R6B0pH5G4V3b0pVbL7DBj4tkhBAppbQUlf6F6Xl9LHu1g==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/merge2": {
      "version": "1.4.1",
      "resolved": "https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz",
      "integrity": "sha512-8q7VEgMJW4J8tcfVPy8g09NcQwZdbwFEqhe/WZkoIzjn/3TGDwtOCYtXGxA3O8tPzpczCCDgv+P2P5y00ZJOOg==",
      "dev": true,
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/micromatch": {
      "version": "4.0.8",
      "resolved": "https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz",
      "integrity": "sha512-PXwfBhYu0hBCPw8Dn0E+WDYb7af3dSLVWKi3HGv84IdF4TyFoC0ysxFd0Goxw7nSv4T/PzEJQxsYsEiFCKo2BA==",
      "dev": true,
      "dependencies": {
        "braces": "^3.0.3",
        "picomatch": "^2.3.1"
      },
      "engines": {
        "node": ">=8.6"
      }
    },
    "node_modules/mime-db": {
      "version": "1.52.0",
      "resolved": "https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz",
      "integrity": "sha512-sPU4uV7dYlvtWJxwwxHD0PuihVNiE7TyAbQ5SWxDCB9mUYvOgroQOwYQQOKPJ8CIbE+1ETVlOoK1UC2nU3gYvg==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/mime-types": {
      "version": "2.1.35",
      "resolved": "https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz",
      "integrity": "sha512-ZDY+bPm5zTTF+YpCrAU9nK0UgICYPT0QtT1NZWFv4s++TNkcgVaT0g6+4R2uI4MjQjzysHB1zxuWL50hzaeXiw==",
      "license": "MIT",
      "dependencies": {
        "mime-db": "1.52.0"
      },
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/minimatch": {
      "version": "3.1.2",
      "resolved": "https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz",
      "integrity": "sha512-J7p63hRiAjw1NDEww1W7i37+ByIrOWO5XQQAzZ3VOcL0PNybwpfmV/N05zFAzwQ9USyEcX6t3UO+K5aqBQOIHw==",
      "dev": true,
      "dependencies": {
        "brace-expansion": "^1.1.7"
      },
      "engines": {
        "node": "*"
      }
    },
    "node_modules/minipass": {
      "version": "7.1.2",
      "resolved": "https://registry.npmjs.org/minipass/-/minipass-7.1.2.tgz",
      "integrity": "sha512-qOOzS1cBTWYF4BH8fVePDBOO9iptMnGUEZwNc/cMWnTV2nVLZ7VoNWEPHkYczZA0pdoA7dl6e7FL659nX9S2aw==",
      "dev": true,
      "engines": {
        "node": ">=16 || 14 >=14.17"
      }
    },
    "node_modules/ms": {
      "version": "2.1.3",
      "resolved": "https://registry.npmjs.org/ms/-/ms-2.1.3.tgz",
      "integrity": "sha512-6FlzubTLZG3J2a/NVCAleEhjzq5oxgHyaCU9yYXvcLsvoVaHJq/s5xXI6/XXP6tz7R9xAOtHnSO/tXtF3WRTlA=="
    },
    "node_modules/mz": {
      "version": "2.7.0",
      "resolved": "https://registry.npmjs.org/mz/-/mz-2.7.0.tgz",
      "integrity": "sha512-z81GNO7nnYMEhrGh9LeymoE4+Yr0Wn5McHIZMK5cfQCl+NDX08sCZgUc9/6MHni9IWuFLm1Z3HTCXu2z9fN62Q==",
      "dev": true,
      "dependencies": {
        "any-promise": "^1.0.0",
        "object-assign": "^4.0.1",
        "thenify-all": "^1.0.0"
      }
    },
    "node_modules/nanoid": {
      "version": "3.3.7",
      "resolved": "https://registry.npmjs.org/nanoid/-/nanoid-3.3.7.tgz",
      "integrity": "sha512-eSRppjcPIatRIMC1U6UngP8XFcz8MQWGQdt1MTBQ7NaAmvXDfvNxbvWV3x2y6CdEUciCSsDHDQZbhYaB8QEo2g==",
      "dev": true,
      "funding": [
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "bin": {
        "nanoid": "bin/nanoid.cjs"
      },
      "engines": {
        "node": "^10 || ^12 || ^13.7 || ^14 || >=15.0.1"
      }
    },
    "node_modules/natural-compare": {
      "version": "1.4.0",
      "resolved": "https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz",
      "integrity": "sha512-OWND8ei3VtNC9h7V60qff3SVobHr996CTwgxubgyQYEpg290h9J0buyECNNJexkFm5sOajh5G116RYA1c8ZMSw==",
      "dev": true
    },
    "node_modules/node-releases": {
      "version": "2.0.18",
      "resolved": "https://registry.npmjs.org/node-releases/-/node-releases-2.0.18.tgz",
      "integrity": "sha512-d9VeXT4SJ7ZeOqGX6R5EM022wpL+eWPooLI+5UpWn2jCT1aosUQEhQP214x33Wkwx3JQMvIm+tIoVOdodFS40g==",
      "dev": true
    },
    "node_modules/normalize-path": {
      "version": "3.0.0",
      "resolved": "https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz",
      "integrity": "sha512-6eZs5Ls3WtCisHWp9S2GUy8dqkpGi4BVSz3GaqiE6ezub0512ESztXUwUB6C6IKbQkY2Pnb/mD4WYojCRwcwLA==",
      "dev": true,
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/normalize-range": {
      "version": "0.1.2",
      "resolved": "https://registry.npmjs.org/normalize-range/-/normalize-range-0.1.2.tgz",
      "integrity": "sha512-bdok/XvKII3nUpklnV6P2hxtMNrCboOjAcyBuQnWEhO665FwrSNRxU+AqpsyvO6LgGYPspN+lu5CLtw4jPRKNA==",
      "dev": true,
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/object-assign": {
      "version": "4.1.1",
      "resolved": "https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz",
      "integrity": "sha512-rJgTQnkUnH1sFw8yT6VSU3zD3sWmu6sZhIseY8VX+GRu3P6F7Fu+JNDoXfklElbLJSnc3FUQHVe4cU5hj+BcUg==",
      "dev": true,
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/object-hash": {
      "version": "3.0.0",
      "resolved": "https://registry.npmjs.org/object-hash/-/object-hash-3.0.0.tgz",
      "integrity": "sha512-RSn9F68PjH9HqtltsSnqYC1XXoWe9Bju5+213R98cNGttag9q9yAOTzdbsqvIa7aNm5WffBZFpWYr2aWrklWAw==",
      "dev": true,
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/optionator": {
      "version": "0.9.4",
      "resolved": "https://registry.npmjs.org/optionator/-/optionator-0.9.4.tgz",
      "integrity": "sha512-6IpQ7mKUxRcZNLIObR0hz7lxsapSSIYNZJwXPGeF0mTVqGKFIXj1DQcMoT22S3ROcLyY/rz0PWaWZ9ayWmad9g==",
      "dev": true,
      "dependencies": {
        "deep-is": "^0.1.3",
        "fast-levenshtein": "^2.0.6",
        "levn": "^0.4.1",
        "prelude-ls": "^1.2.1",
        "type-check": "^0.4.0",
        "word-wrap": "^1.2.5"
      },
      "engines": {
        "node": ">= 0.8.0"
      }
    },
    "node_modules/p-limit": {
      "version": "3.1.0",
      "resolved": "https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz",
      "integrity": "sha512-TYOanM3wGwNGsZN2cVTYPArw454xnXj5qmWF1bEoAc4+cU/ol7GVh7odevjp1FNHduHc3KZMcFduxU5Xc6uJRQ==",
      "dev": true,
      "dependencies": {
        "yocto-queue": "^0.1.0"
      },
      "engines": {
        "node": ">=10"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/p-locate": {
      "version": "5.0.0",
      "resolved": "https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz",
      "integrity": "sha512-LaNjtRWUBY++zB5nE/NwcaoMylSPk+S+ZHNB1TzdbMJMny6dynpAGt7X/tl/QYq3TIeE6nxHppbo2LGymrG5Pw==",
      "dev": true,
      "dependencies": {
        "p-limit": "^3.0.2"
      },
      "engines": {
        "node": ">=10"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/package-json-from-dist": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/package-json-from-dist/-/package-json-from-dist-1.0.1.tgz",
      "integrity": "sha512-UEZIS3/by4OC8vL3P2dTXRETpebLI2NiI5vIrjaD/5UtrkFX/tNbwjTSRAGC/+7CAo2pIcBaRgWmcBBHcsaCIw==",
      "dev": true
    },
    "node_modules/parent-module": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz",
      "integrity": "sha512-GQ2EWRpQV8/o+Aw8YqtfZZPfNRWZYkbidE9k5rpl/hC3vtHHBfGm2Ifi6qWV+coDGkrUKZAxE3Lot5kcsRlh+g==",
      "dev": true,
      "dependencies": {
        "callsites": "^3.0.0"
      },
      "engines": {
        "node": ">=6"
      }
    },
    "node_modules/path-exists": {
      "version": "4.0.0",
      "resolved": "https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz",
      "integrity": "sha512-ak9Qy5Q7jYb2Wwcey5Fpvg2KoAc/ZIhLSLOSBmRmygPsGwkVVt0fZa0qrtMz+m6tJTAHfZQ8FnmB4MG4LWy7/w==",
      "dev": true,
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/path-key": {
      "version": "3.1.1",
      "resolved": "https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz",
      "integrity": "sha512-ojmeN0qd+y0jszEtoY48r0Peq5dwMEkIlCOu6Q5f41lfkswXuKtYrhgoTpLnyIcHm24Uhqx+5Tqm2InSwLhE6Q==",
      "dev": true,
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/path-parse": {
      "version": "1.0.7",
      "resolved": "https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz",
      "integrity": "sha512-LDJzPVEEEPR+y48z93A0Ed0yXb8pAByGWo/k5YYdYgpY2/2EsOsksJrq7lOHxryrVOn1ejG6oAp8ahvOIQD8sw==",
      "dev": true
    },
    "node_modules/path-scurry": {
      "version": "1.11.1",
      "resolved": "https://registry.npmjs.org/path-scurry/-/path-scurry-1.11.1.tgz",
      "integrity": "sha512-Xa4Nw17FS9ApQFJ9umLiJS4orGjm7ZzwUrwamcGQuHSzDyth9boKDaycYdDcZDuqYATXw4HFXgaqWTctW/v1HA==",
      "dev": true,
      "dependencies": {
        "lru-cache": "^10.2.0",
        "minipass": "^5.0.0 || ^6.0.2 || ^7.0.0"
      },
      "engines": {
        "node": ">=16 || 14 >=14.18"
      },
      "funding": {
        "url": "https://github.com/sponsors/isaacs"
      }
    },
    "node_modules/path-scurry/node_modules/lru-cache": {
      "version": "10.4.3",
      "resolved": "https://registry.npmjs.org/lru-cache/-/lru-cache-10.4.3.tgz",
      "integrity": "sha512-JNAzZcXrCt42VGLuYz0zfAzDfAvJWW6AfYlDBQyDV5DClI2m5sAmK+OIO7s59XfsRsWHp02jAJrRadPRGTt6SQ==",
      "dev": true
    },
    "node_modules/picocolors": {
      "version": "1.1.1",
      "resolved": "https://registry.npmjs.org/picocolors/-/picocolors-1.1.1.tgz",
      "integrity": "sha512-xceH2snhtb5M9liqDsmEw56le376mTZkEX/jEb/RxNFyegNul7eNslCXP9FDj/Lcu0X8KEyMceP2ntpaHrDEVA==",
      "dev": true
    },
    "node_modules/picomatch": {
      "version": "2.3.1",
      "resolved": "https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz",
      "integrity": "sha512-JU3teHTNjmE2VCGFzuY8EXzCDVwEqB2a8fsIvwaStHhAWJEeVd1o1QD80CU6+ZdEXXSLbSsuLwJjkCBWqRQUVA==",
      "dev": true,
      "engines": {
        "node": ">=8.6"
      },
      "funding": {
        "url": "https://github.com/sponsors/jonschlinkert"
      }
    },
    "node_modules/pify": {
      "version": "2.3.0",
      "resolved": "https://registry.npmjs.org/pify/-/pify-2.3.0.tgz",
      "integrity": "sha512-udgsAY+fTnvv7kI7aaxbqwWNb0AHiB0qBO89PZKPkoTmGOgdbrHDKD+0B2X4uTfJ/FT1R09r9gTsjUjNJotuog==",
      "dev": true,
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/pirates": {
      "version": "4.0.6",
      "resolved": "https://registry.npmjs.org/pirates/-/pirates-4.0.6.tgz",
      "integrity": "sha512-saLsH7WeYYPiD25LDuLRRY/i+6HaPYr6G1OUlN39otzkSTxKnubR9RTxS3/Kk50s1g2JTgFwWQDQyplC5/SHZg==",
      "dev": true,
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/postcss": {
      "version": "8.4.47",
      "resolved": "https://registry.npmjs.org/postcss/-/postcss-8.4.47.tgz",
      "integrity": "sha512-56rxCq7G/XfB4EkXq9Egn5GCqugWvDFjafDOThIdMBsI15iqPqR5r15TfSr1YPYeEI19YeaXMCbY6u88Y76GLQ==",
      "dev": true,
      "funding": [
        {
          "type": "opencollective",
          "url": "https://opencollective.com/postcss/"
        },
        {
          "type": "tidelift",
          "url": "https://tidelift.com/funding/github/npm/postcss"
        },
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "dependencies": {
        "nanoid": "^3.3.7",
        "picocolors": "^1.1.0",
        "source-map-js": "^1.2.1"
      },
      "engines": {
        "node": "^10 || ^12 || >=14"
      }
    },
    "node_modules/postcss-import": {
      "version": "15.1.0",
      "resolved": "https://registry.npmjs.org/postcss-import/-/postcss-import-15.1.0.tgz",
      "integrity": "sha512-hpr+J05B2FVYUAXHeK1YyI267J/dDDhMU6B6civm8hSY1jYJnBXxzKDKDswzJmtLHryrjhnDjqqp/49t8FALew==",
      "dev": true,
      "dependencies": {
        "postcss-value-parser": "^4.0.0",
        "read-cache": "^1.0.0",
        "resolve": "^1.1.7"
      },
      "engines": {
        "node": ">=14.0.0"
      },
      "peerDependencies": {
        "postcss": "^8.0.0"
      }
    },
    "node_modules/postcss-js": {
      "version": "4.0.1",
      "resolved": "https://registry.npmjs.org/postcss-js/-/postcss-js-4.0.1.tgz",
      "integrity": "sha512-dDLF8pEO191hJMtlHFPRa8xsizHaM82MLfNkUHdUtVEV3tgTp5oj+8qbEqYM57SLfc74KSbw//4SeJma2LRVIw==",
      "dev": true,
      "dependencies": {
        "camelcase-css": "^2.0.1"
      },
      "engines": {
        "node": "^12 || ^14 || >= 16"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/postcss/"
      },
      "peerDependencies": {
        "postcss": "^8.4.21"
      }
    },
    "node_modules/postcss-load-config": {
      "version": "4.0.2",
      "resolved": "https://registry.npmjs.org/postcss-load-config/-/postcss-load-config-4.0.2.tgz",
      "integrity": "sha512-bSVhyJGL00wMVoPUzAVAnbEoWyqRxkjv64tUl427SKnPrENtq6hJwUojroMz2VB+Q1edmi4IfrAPpami5VVgMQ==",
      "dev": true,
      "funding": [
        {
          "type": "opencollective",
          "url": "https://opencollective.com/postcss/"
        },
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "dependencies": {
        "lilconfig": "^3.0.0",
        "yaml": "^2.3.4"
      },
      "engines": {
        "node": ">= 14"
      },
      "peerDependencies": {
        "postcss": ">=8.0.9",
        "ts-node": ">=9.0.0"
      },
      "peerDependenciesMeta": {
        "postcss": {
          "optional": true
        },
        "ts-node": {
          "optional": true
        }
      }
    },
    "node_modules/postcss-nested": {
      "version": "6.2.0",
      "resolved": "https://registry.npmjs.org/postcss-nested/-/postcss-nested-6.2.0.tgz",
      "integrity": "sha512-HQbt28KulC5AJzG+cZtj9kvKB93CFCdLvog1WFLf1D+xmMvPGlBstkpTEZfK5+AN9hfJocyBFCNiqyS48bpgzQ==",
      "dev": true,
      "funding": [
        {
          "type": "opencollective",
          "url": "https://opencollective.com/postcss/"
        },
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "dependencies": {
        "postcss-selector-parser": "^6.1.1"
      },
      "engines": {
        "node": ">=12.0"
      },
      "peerDependencies": {
        "postcss": "^8.2.14"
      }
    },
    "node_modules/postcss-selector-parser": {
      "version": "6.1.2",
      "resolved": "https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.1.2.tgz",
      "integrity": "sha512-Q8qQfPiZ+THO/3ZrOrO0cJJKfpYCagtMUkXbnEfmgUjwXg6z/WBeOyS9APBBPCTSiDV+s4SwQGu8yFsiMRIudg==",
      "dev": true,
      "dependencies": {
        "cssesc": "^3.0.0",
        "util-deprecate": "^1.0.2"
      },
      "engines": {
        "node": ">=4"
      }
    },
    "node_modules/postcss-value-parser": {
      "version": "4.2.0",
      "resolved": "https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz",
      "integrity": "sha512-1NNCs6uurfkVbeXG4S8JFT9t19m45ICnif8zWLd5oPSZ50QnwMfK+H3jv408d4jw/7Bttv5axS5IiHoLaVNHeQ==",
      "dev": true
    },
    "node_modules/prelude-ls": {
      "version": "1.2.1",
      "resolved": "https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz",
      "integrity": "sha512-vkcDPrRZo1QZLbn5RLGPpg/WmIQ65qoWWhcGKf/b5eplkkarX0m9z8ppCat4mlOqUsWpyNuYgO3VRyrYHSzX5g==",
      "dev": true,
      "engines": {
        "node": ">= 0.8.0"
      }
    },
    "node_modules/proxy-from-env": {
      "version": "2.1.0",
      "resolved": "https://registry.npmjs.org/proxy-from-env/-/proxy-from-env-2.1.0.tgz",
      "integrity": "sha512-cJ+oHTW1VAEa8cJslgmUZrc+sjRKgAKl3Zyse6+PV38hZe/V6Z14TbCuXcan9F9ghlz4QrFr2c92TNF82UkYHA==",
      "license": "MIT",
      "engines": {
        "node": ">=10"
      }
    },
    "node_modules/punycode": {
      "version": "2.3.1",
      "resolved": "https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz",
      "integrity": "sha512-vYt7UD1U9Wg6138shLtLOvdAu+8DsC/ilFtEVHcH+wydcSpNE20AfSOduf6MkRFahL5FY7X1oU7nKVZFtfq8Fg==",
      "dev": true,
      "engines": {
        "node": ">=6"
      }
    },
    "node_modules/queue-microtask": {
      "version": "1.2.3",
      "resolved": "https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz",
      "integrity": "sha512-NuaNSa6flKT5JaSYQzJok04JzTL1CA6aGhv5rfLW3PgqA+M2ChpZQnAC8h8i4ZFkBS8X5RqkDBHA7r4hej3K9A==",
      "dev": true,
      "funding": [
        {
          "type": "github",
          "url": "https://github.com/sponsors/feross"
        },
        {
          "type": "patreon",
          "url": "https://www.patreon.com/feross"
        },
        {
          "type": "consulting",
          "url": "https://feross.org/support"
        }
      ]
    },
    "node_modules/react": {
      "version": "18.3.1",
      "resolved": "https://registry.npmjs.org/react/-/react-18.3.1.tgz",
      "integrity": "sha512-wS+hAgJShR0KhEvPJArfuPVN1+Hz1t0Y6n5jLrGQbkb4urgPE/0Rve+1kMB1v/oWgHgm4WIcV+i7F2pTVj+2iQ==",
      "dependencies": {
        "loose-envify": "^1.1.0"
      },
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/react-dom": {
      "version": "18.3.1",
      "resolved": "https://registry.npmjs.org/react-dom/-/react-dom-18.3.1.tgz",
      "integrity": "sha512-5m4nQKp+rZRb09LNH59GM4BxTh9251/ylbKIbpe7TpGxfJ+9kv6BLkLBXIjjspbgbnIBNqlI23tRnTWT0snUIw==",
      "dependencies": {
        "loose-envify": "^1.1.0",
        "scheduler": "^0.23.2"
      },
      "peerDependencies": {
        "react": "^18.3.1"
      }
    },
    "node_modules/react-leaflet": {
      "version": "5.0.0",
      "resolved": "https://registry.npmjs.org/react-leaflet/-/react-leaflet-5.0.0.tgz",
      "integrity": "sha512-CWbTpr5vcHw5bt9i4zSlPEVQdTVcML390TjeDG0cK59z1ylexpqC6M1PJFjV8jD7CF+ACBFsLIDs6DRMoLEofw==",
      "license": "Hippocratic-2.1",
      "dependencies": {
        "@react-leaflet/core": "^3.0.0"
      },
      "peerDependencies": {
        "leaflet": "^1.9.0",
        "react": "^19.0.0",
        "react-dom": "^19.0.0"
      }
    },
    "node_modules/react-refresh": {
      "version": "0.14.2",
      "resolved": "https://registry.npmjs.org/react-refresh/-/react-refresh-0.14.2.tgz",
      "integrity": "sha512-jCvmsr+1IUSMUyzOkRcvnVbX3ZYC6g9TDrDbFuFmRDq7PD4yaGbLKNQL6k2jnArV8hjYxh7hVhAZB6s9HDGpZA==",
      "dev": true,
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/react-router": {
      "version": "7.17.0",
      "resolved": "https://registry.npmjs.org/react-router/-/react-router-7.17.0.tgz",
      "integrity": "sha512-FDELK7rTMlCHO5+reyXsPlmfr7N1F91lPHsWYfMEGQm/KQ+F4JFM8jGoeQDmDvdTs93Fw9aSilH+uKRb4/jXvQ==",
      "license": "MIT",
      "dependencies": {
        "cookie": "^1.0.1",
        "set-cookie-parser": "^2.6.0"
      },
      "engines": {
        "node": ">=20.0.0"
      },
      "peerDependencies": {
        "react": ">=18",
        "react-dom": ">=18"
      },
      "peerDependenciesMeta": {
        "react-dom": {
          "optional": true
        }
      }
    },
    "node_modules/react-router-dom": {
      "version": "7.17.0",
      "resolved": "https://registry.npmjs.org/react-router-dom/-/react-router-dom-7.17.0.tgz",
      "integrity": "sha512-fyU2yjGups/hE6Xz0I5ZYbVL8Gx29eCjgpHaRaTaVU+OOAdfRX05KsvyRm0GO8YQwOkhpU3MurW1jyMUJn+zSw==",
      "license": "MIT",
      "dependencies": {
        "react-router": "7.17.0"
      },
      "engines": {
        "node": ">=20.0.0"
      },
      "peerDependencies": {
        "react": ">=18",
        "react-dom": ">=18"
      }
    },
    "node_modules/read-cache": {
      "version": "1.0.0",
      "resolved": "https://registry.npmjs.org/read-cache/-/read-cache-1.0.0.tgz",
      "integrity": "sha512-Owdv/Ft7IjOgm/i0xvNDZ1LrRANRfew4b2prF3OWMQLxLfu3bS8FVhCsrSCMK4lR56Y9ya+AThoTpDCTxCmpRA==",
      "dev": true,
      "dependencies": {
        "pify": "^2.3.0"
      }
    },
    "node_modules/readdirp": {
      "version": "3.6.0",
      "resolved": "https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz",
      "integrity": "sha512-hOS089on8RduqdbhvQ5Z37A0ESjsqz6qnRcffsMU3495FuTdqSm+7bhJ29JvIOsBDEEnan5DPu9t3To9VRlMzA==",
      "dev": true,
      "dependencies": {
        "picomatch": "^2.2.1"
      },
      "engines": {
        "node": ">=8.10.0"
      }
    },
    "node_modules/resolve": {
      "version": "1.22.8",
      "resolved": "https://registry.npmjs.org/resolve/-/resolve-1.22.8.tgz",
      "integrity": "sha512-oKWePCxqpd6FlLvGV1VU0x7bkPmmCNolxzjMf4NczoDnQcIWrAF+cPtZn5i6n+RfD2d9i0tzpKnG6Yk168yIyw==",
      "dev": true,
      "dependencies": {
        "is-core-module": "^2.13.0",
        "path-parse": "^1.0.7",
        "supports-preserve-symlinks-flag": "^1.0.0"
      },
      "bin": {
        "resolve": "bin/resolve"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/resolve-from": {
      "version": "4.0.0",
      "resolved": "https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz",
      "integrity": "sha512-pb/MYmXstAkysRFx8piNI1tGFNQIFA3vkE3Gq4EuA1dF6gHp/+vgZqsCGJapvy8N3Q+4o7FwvquPJcnZ7RYy4g==",
      "dev": true,
      "engines": {
        "node": ">=4"
      }
    },
    "node_modules/reusify": {
      "version": "1.0.4",
      "resolved": "https://registry.npmjs.org/reusify/-/reusify-1.0.4.tgz",
      "integrity": "sha512-U9nH88a3fc/ekCF1l0/UP1IosiuIjyTh7hBvXVMHYgVcfGvt897Xguj2UOLDeI5BG2m7/uwyaLVT6fbtCwTyzw==",
      "dev": true,
      "engines": {
        "iojs": ">=1.0.0",
        "node": ">=0.10.0"
      }
    },
    "node_modules/rollup": {
      "version": "4.24.0",
      "resolved": "https://registry.npmjs.org/rollup/-/rollup-4.24.0.tgz",
      "integrity": "sha512-DOmrlGSXNk1DM0ljiQA+i+o0rSLhtii1je5wgk60j49d1jHT5YYttBv1iWOnYSTG+fZZESUOSNiAl89SIet+Cg==",
      "dev": true,
      "dependencies": {
        "@types/estree": "1.0.6"
      },
      "bin": {
        "rollup": "dist/bin/rollup"
      },
      "engines": {
        "node": ">=18.0.0",
        "npm": ">=8.0.0"
      },
      "optionalDependencies": {
        "@rollup/rollup-android-arm-eabi": "4.24.0",
        "@rollup/rollup-android-arm64": "4.24.0",
        "@rollup/rollup-darwin-arm64": "4.24.0",
        "@rollup/rollup-darwin-x64": "4.24.0",
        "@rollup/rollup-linux-arm-gnueabihf": "4.24.0",
        "@rollup/rollup-linux-arm-musleabihf": "4.24.0",
        "@rollup/rollup-linux-arm64-gnu": "4.24.0",
        "@rollup/rollup-linux-arm64-musl": "4.24.0",
        "@rollup/rollup-linux-powerpc64le-gnu": "4.24.0",
        "@rollup/rollup-linux-riscv64-gnu": "4.24.0",
        "@rollup/rollup-linux-s390x-gnu": "4.24.0",
        "@rollup/rollup-linux-x64-gnu": "4.24.0",
        "@rollup/rollup-linux-x64-musl": "4.24.0",
        "@rollup/rollup-win32-arm64-msvc": "4.24.0",
        "@rollup/rollup-win32-ia32-msvc": "4.24.0",
        "@rollup/rollup-win32-x64-msvc": "4.24.0",
        "fsevents": "~2.3.2"
      }
    },
    "node_modules/run-parallel": {
      "version": "1.2.0",
      "resolved": "https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz",
      "integrity": "sha512-5l4VyZR86LZ/lDxZTR6jqL8AFE2S0IFLMP26AbjsLVADxHdhB/c0GUsH+y39UfCi3dzz8OlQuPmnaJOMoDHQBA==",
      "dev": true,
      "funding": [
        {
          "type": "github",
          "url": "https://github.com/sponsors/feross"
        },
        {
          "type": "patreon",
          "url": "https://www.patreon.com/feross"
        },
        {
          "type": "consulting",
          "url": "https://feross.org/support"
        }
      ],
      "dependencies": {
        "queue-microtask": "^1.2.2"
      }
    },
    "node_modules/scheduler": {
      "version": "0.23.2",
      "resolved": "https://registry.npmjs.org/scheduler/-/scheduler-0.23.2.tgz",
      "integrity": "sha512-UOShsPwz7NrMUqhR6t0hWjFduvOzbtv7toDH1/hIrfRNIDBnnBWd0CwJTGvTpngVlmwGCdP9/Zl/tVrDqcuYzQ==",
      "dependencies": {
        "loose-envify": "^1.1.0"
      }
    },
    "node_modules/semver": {
      "version": "6.3.1",
      "resolved": "https://registry.npmjs.org/semver/-/semver-6.3.1.tgz",
      "integrity": "sha512-BR7VvDCVHO+q2xBEWskxS6DJE1qRnb7DxzUrogb71CWoSficBxYsiAGd+Kl0mmq/MprG9yArRkyrQxTO6XjMzA==",
      "dev": true,
      "bin": {
        "semver": "bin/semver.js"
      }
    },
    "node_modules/set-cookie-parser": {
      "version": "2.7.2",
      "resolved": "https://registry.npmjs.org/set-cookie-parser/-/set-cookie-parser-2.7.2.tgz",
      "integrity": "sha512-oeM1lpU/UvhTxw+g3cIfxXHyJRc/uidd3yK1P242gzHds0udQBYzs3y8j4gCCW+ZJ7ad0yctld8RYO+bdurlvw==",
      "license": "MIT"
    },
    "node_modules/shebang-command": {
      "version": "2.0.0",
      "resolved": "https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz",
      "integrity": "sha512-kHxr2zZpYtdmrN1qDjrrX/Z1rR1kG8Dx+gkpK1G4eXmvXswmcE1hTWBWYUzlraYw1/yZp6YuDY77YtvbN0dmDA==",
      "dev": true,
      "dependencies": {
        "shebang-regex": "^3.0.0"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/shebang-regex": {
      "version": "3.0.0",
      "resolved": "https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz",
      "integrity": "sha512-7++dFhtcx3353uBaq8DDR4NuxBetBzC7ZQOhmTQInHEd6bSrXdiEyzCvG07Z44UYdLShWUyXt5M/yhz8ekcb1A==",
      "dev": true,
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/signal-exit": {
      "version": "4.1.0",
      "resolved": "https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz",
      "integrity": "sha512-bzyZ1e88w9O1iNJbKnOlvYTrWPDl46O1bG0D3XInv+9tkPrxrN8jUUTiFlDkkmKWgn1M6CfIA13SuGqOa9Korw==",
      "dev": true,
      "engines": {
        "node": ">=14"
      },
      "funding": {
        "url": "https://github.com/sponsors/isaacs"
      }
    },
    "node_modules/source-map-js": {
      "version": "1.2.1",
      "resolved": "https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.1.tgz",
      "integrity": "sha512-UXWMKhLOwVKb728IUtQPXxfYU+usdybtUrK/8uGE8CQMvrhOpwvzDBwj0QhSL7MQc7vIsISBG8VQ8+IDQxpfQA==",
      "dev": true,
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/string-width": {
      "version": "5.1.2",
      "resolved": "https://registry.npmjs.org/string-width/-/string-width-5.1.2.tgz",
      "integrity": "sha512-HnLOCR3vjcY8beoNLtcjZ5/nxn2afmME6lhrDrebokqMap+XbeW8n9TXpPDOqdGK5qcI3oT0GKTW6wC7EMiVqA==",
      "dev": true,
      "dependencies": {
        "eastasianwidth": "^0.2.0",
        "emoji-regex": "^9.2.2",
        "strip-ansi": "^7.0.1"
      },
      "engines": {
        "node": ">=12"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/string-width-cjs": {
      "name": "string-width",
      "version": "4.2.3",
      "resolved": "https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz",
      "integrity": "sha512-wKyQRQpjJ0sIp62ErSZdGsjMJWsap5oRNihHhu6G7JVO/9jIB6UyevL+tXuOqrng8j/cxKTWyWUwvSTriiZz/g==",
      "dev": true,
      "dependencies": {
        "emoji-regex": "^8.0.0",
        "is-fullwidth-code-point": "^3.0.0",
        "strip-ansi": "^6.0.1"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/string-width-cjs/node_modules/ansi-regex": {
      "version": "5.0.1",
      "resolved": "https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz",
      "integrity": "sha512-quJQXlTSUGL2LH9SUXo8VwsY4soanhgo6LNSm84E1LBcE8s3O0wpdiRzyR9z/ZZJMlMWv37qOOb9pdJlMUEKFQ==",
      "dev": true,
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/string-width-cjs/node_modules/emoji-regex": {
      "version": "8.0.0",
      "resolved": "https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz",
      "integrity": "sha512-MSjYzcWNOA0ewAHpz0MxpYFvwg6yjy1NG3xteoqz644VCo/RPgnr1/GGt+ic3iJTzQ8Eu3TdM14SawnVUmGE6A==",
      "dev": true
    },
    "node_modules/string-width-cjs/node_modules/strip-ansi": {
      "version": "6.0.1",
      "resolved": "https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz",
      "integrity": "sha512-Y38VPSHcqkFrCpFnQ9vuSXmquuv5oXOKpGeT6aGrr3o3Gc9AlVa6JBfUSOCnbxGGZF+/0ooI7KrPuUSztUdU5A==",
      "dev": true,
      "dependencies": {
        "ansi-regex": "^5.0.1"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/strip-ansi": {
      "version": "7.1.0",
      "resolved": "https://registry.npmjs.org/strip-ansi/-/strip-ansi-7.1.0.tgz",
      "integrity": "sha512-iq6eVVI64nQQTRYq2KtEg2d2uU7LElhTJwsH4YzIHZshxlgZms/wIc4VoDQTlG/IvVIrBKG06CrZnp0qv7hkcQ==",
      "dev": true,
      "dependencies": {
        "ansi-regex": "^6.0.1"
      },
      "engines": {
        "node": ">=12"
      },
      "funding": {
        "url": "https://github.com/chalk/strip-ansi?sponsor=1"
      }
    },
    "node_modules/strip-ansi-cjs": {
      "name": "strip-ansi",
      "version": "6.0.1",
      "resolved": "https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz",
      "integrity": "sha512-Y38VPSHcqkFrCpFnQ9vuSXmquuv5oXOKpGeT6aGrr3o3Gc9AlVa6JBfUSOCnbxGGZF+/0ooI7KrPuUSztUdU5A==",
      "dev": true,
      "dependencies": {
        "ansi-regex": "^5.0.1"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/strip-ansi-cjs/node_modules/ansi-regex": {
      "version": "5.0.1",
      "resolved": "https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz",
      "integrity": "sha512-quJQXlTSUGL2LH9SUXo8VwsY4soanhgo6LNSm84E1LBcE8s3O0wpdiRzyR9z/ZZJMlMWv37qOOb9pdJlMUEKFQ==",
      "dev": true,
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/strip-json-comments": {
      "version": "3.1.1",
      "resolved": "https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz",
      "integrity": "sha512-6fPc+R4ihwqP6N/aIv2f1gMH8lOVtWQHoqC4yK6oSDVVocumAsfCqjkXnqiYMhmMwS/mEHLp7Vehlt3ql6lEig==",
      "dev": true,
      "engines": {
        "node": ">=8"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/sucrase": {
      "version": "3.35.0",
      "resolved": "https://registry.npmjs.org/sucrase/-/sucrase-3.35.0.tgz",
      "integrity": "sha512-8EbVDiu9iN/nESwxeSxDKe0dunta1GOlHufmSSXxMD2z2/tMZpDMpvXQGsc+ajGo8y2uYUmixaSRUc/QPoQ0GA==",
      "dev": true,
      "dependencies": {
        "@jridgewell/gen-mapping": "^0.3.2",
        "commander": "^4.0.0",
        "glob": "^10.3.10",
        "lines-and-columns": "^1.1.6",
        "mz": "^2.7.0",
        "pirates": "^4.0.1",
        "ts-interface-checker": "^0.1.9"
      },
      "bin": {
        "sucrase": "bin/sucrase",
        "sucrase-node": "bin/sucrase-node"
      },
      "engines": {
        "node": ">=16 || 14 >=14.17"
      }
    },
    "node_modules/supports-color": {
      "version": "5.5.0",
      "resolved": "https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz",
      "integrity": "sha512-QjVjwdXIt408MIiAqCX4oUKsgU2EqAGzs2Ppkm4aQYbjm+ZEWEcW4SfFNTr4uMNZma0ey4f5lgLrkB0aX0QMow==",
      "dev": true,
      "dependencies": {
        "has-flag": "^3.0.0"
      },
      "engines": {
        "node": ">=4"
      }
    },
    "node_modules/supports-preserve-symlinks-flag": {
      "version": "1.0.0",
      "resolved": "https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz",
      "integrity": "sha512-ot0WnXS9fgdkgIcePe6RHNk1WA8+muPa6cSjeR3V8K27q9BB1rTE3R1p7Hv0z1ZyAc8s6Vvv8DIyWf681MAt0w==",
      "dev": true,
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/tailwindcss": {
      "version": "3.4.17",
      "resolved": "https://registry.npmjs.org/tailwindcss/-/tailwindcss-3.4.17.tgz",
      "integrity": "sha512-w33E2aCvSDP0tW9RZuNXadXlkHXqFzSkQew/aIa2i/Sj8fThxwovwlXHSPXTbAHwEIhBFXAedUhP2tueAKP8Og==",
      "dev": true,
      "dependencies": {
        "@alloc/quick-lru": "^5.2.0",
        "arg": "^5.0.2",
        "chokidar": "^3.6.0",
        "didyoumean": "^1.2.2",
        "dlv": "^1.1.3",
        "fast-glob": "^3.3.2",
        "glob-parent": "^6.0.2",
        "is-glob": "^4.0.3",
        "jiti": "^1.21.6",
        "lilconfig": "^3.1.3",
        "micromatch": "^4.0.8",
        "normalize-path": "^3.0.0",
        "object-hash": "^3.0.0",
        "picocolors": "^1.1.1",
        "postcss": "^8.4.47",
        "postcss-import": "^15.1.0",
        "postcss-js": "^4.0.1",
        "postcss-load-config": "^4.0.2",
        "postcss-nested": "^6.2.0",
        "postcss-selector-parser": "^6.1.2",
        "resolve": "^1.22.8",
        "sucrase": "^3.35.0"
      },
      "bin": {
        "tailwind": "lib/cli.js",
        "tailwindcss": "lib/cli.js"
      },
      "engines": {
        "node": ">=14.0.0"
      }
    },
    "node_modules/text-table": {
      "version": "0.2.0",
      "resolved": "https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz",
      "integrity": "sha512-N+8UisAXDGk8PFXP4HAzVR9nbfmVJ3zYLAWiTIoqC5v5isinhr+r5uaO8+7r3BMfuNIufIsA7RdpVgacC2cSpw==",
      "dev": true
    },
    "node_modules/thenify": {
      "version": "3.3.1",
      "resolved": "https://registry.npmjs.org/thenify/-/thenify-3.3.1.tgz",
      "integrity": "sha512-RVZSIV5IG10Hk3enotrhvz0T9em6cyHBLkH/YAZuKqd8hRkKhSfCGIcP2KUY0EPxndzANBmNllzWPwak+bheSw==",
      "dev": true,
      "dependencies": {
        "any-promise": "^1.0.0"
      }
    },
    "node_modules/thenify-all": {
      "version": "1.6.0",
      "resolved": "https://registry.npmjs.org/thenify-all/-/thenify-all-1.6.0.tgz",
      "integrity": "sha512-RNxQH/qI8/t3thXJDwcstUO4zeqo64+Uy/+sNVRBx4Xn2OX+OZ9oP+iJnNFqplFra2ZUVeKCSa2oVWi3T4uVmA==",
      "dev": true,
      "dependencies": {
        "thenify": ">= 3.1.0 < 4"
      },
      "engines": {
        "node": ">=0.8"
      }
    },
    "node_modules/to-fast-properties": {
      "version": "2.0.0",
      "resolved": "https://registry.npmjs.org/to-fast-properties/-/to-fast-properties-2.0.0.tgz",
      "integrity": "sha512-/OaKK0xYrs3DmxRYqL/yDc+FxFUVYhDlXMhRmv3z915w2HF1tnN1omB354j8VUGO/hbRzyD6Y3sA7v7GS/ceog==",
      "dev": true,
      "engines": {
        "node": ">=4"
      }
    },
    "node_modules/to-regex-range": {
      "version": "5.0.1",
      "resolved": "https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz",
      "integrity": "sha512-65P7iz6X5yEr1cwcgvQxbbIw7Uk3gOy5dIdtZ4rDveLqhrdJP+Li/Hx6tyK0NEb+2GCyneCMJiGqrADCSNk8sQ==",
      "dev": true,
      "dependencies": {
        "is-number": "^7.0.0"
      },
      "engines": {
        "node": ">=8.0"
      }
    },
    "node_modules/tr46": {
      "version": "0.0.3",
      "resolved": "https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz",
      "integrity": "sha512-N3WMsuqV66lT30CrXNbEjx4GEwlow3v6rr4mCcv6prnfwhS01rkgyFdjPNBYd9br7LpXV1+Emh01fHnq2Gdgrw=="
    },
    "node_modules/ts-api-utils": {
      "version": "1.3.0",
      "resolved": "https://registry.npmjs.org/ts-api-utils/-/ts-api-utils-1.3.0.tgz",
      "integrity": "sha512-UQMIo7pb8WRomKR1/+MFVLTroIvDVtMX3K6OUir8ynLyzB8Jeriont2bTAtmNPa1ekAgN7YPDyf6V+ygrdU+eQ==",
      "dev": true,
      "engines": {
        "node": ">=16"
      },
      "peerDependencies": {
        "typescript": ">=4.2.0"
      }
    },
    "node_modules/ts-interface-checker": {
      "version": "0.1.13",
      "resolved": "https://registry.npmjs.org/ts-interface-checker/-/ts-interface-checker-0.1.13.tgz",
      "integrity": "sha512-Y/arvbn+rrz3JCKl9C4kVNfTfSm2/mEp5FSz5EsZSANGPSlQrpRI5M4PKF+mJnE52jOO90PnPSc3Ur3bTQw0gA==",
      "dev": true
    },
    "node_modules/type-check": {
      "version": "0.4.0",
      "resolved": "https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz",
      "integrity": "sha512-XleUoc9uwGXqjWwXaUTZAmzMcFZ5858QA2vvx1Ur5xIcixXIP+8LnFDgRplU30us6teqdlskFfu+ae4K79Ooew==",
      "dev": true,
      "dependencies": {
        "prelude-ls": "^1.2.1"
      },
      "engines": {
        "node": ">= 0.8.0"
      }
    },
    "node_modules/typescript": {
      "version": "5.6.3",
      "resolved": "https://registry.npmjs.org/typescript/-/typescript-5.6.3.tgz",
      "integrity": "sha512-hjcS1mhfuyi4WW8IWtjP7brDrG2cuDZukyrYrSauoXGNgx0S7zceP07adYkJycEr56BOUTNPzbInooiN3fn1qw==",
      "dev": true,
      "bin": {
        "tsc": "bin/tsc",
        "tsserver": "bin/tsserver"
      },
      "engines": {
        "node": ">=14.17"
      }
    },
    "node_modules/typescript-eslint": {
      "version": "8.8.1",
      "resolved": "https://registry.npmjs.org/typescript-eslint/-/typescript-eslint-8.8.1.tgz",
      "integrity": "sha512-R0dsXFt6t4SAFjUSKFjMh4pXDtq04SsFKCVGDP3ZOzNP7itF0jBcZYU4fMsZr4y7O7V7Nc751dDeESbe4PbQMQ==",
      "dev": true,
      "dependencies": {
        "@typescript-eslint/eslint-plugin": "8.8.1",
        "@typescript-eslint/parser": "8.8.1",
        "@typescript-eslint/utils": "8.8.1"
      },
      "engines": {
        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/typescript-eslint"
      },
      "peerDependenciesMeta": {
        "typescript": {
          "optional": true
        }
      }
    },
    "node_modules/undici-types": {
      "version": "7.10.0",
      "resolved": "https://registry.npmjs.org/undici-types/-/undici-types-7.10.0.tgz",
      "integrity": "sha512-t5Fy/nfn+14LuOc2KNYg75vZqClpAiqscVvMygNnlsHBFpSXdJaYtXMcdNLpl/Qvc3P2cB3s6lOV51nqsFq4ag=="
    },
    "node_modules/update-browserslist-db": {
      "version": "1.1.1",
      "resolved": "https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.1.1.tgz",
      "integrity": "sha512-R8UzCaa9Az+38REPiJ1tXlImTJXlVfgHZsglwBD/k6nj76ctsH1E3q4doGrukiLQd3sGQYu56r5+lo5r94l29A==",
      "dev": true,
      "funding": [
        {
          "type": "opencollective",
          "url": "https://opencollective.com/browserslist"
        },
        {
          "type": "tidelift",
          "url": "https://tidelift.com/funding/github/npm/browserslist"
        },
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "dependencies": {
        "escalade": "^3.2.0",
        "picocolors": "^1.1.0"
      },
      "bin": {
        "update-browserslist-db": "cli.js"
      },
      "peerDependencies": {
        "browserslist": ">= 4.21.0"
      }
    },
    "node_modules/uri-js": {
      "version": "4.4.1",
      "resolved": "https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz",
      "integrity": "sha512-7rKUyy33Q1yc98pQ1DAmLtwX109F7TIfWlW1Ydo8Wl1ii1SeHieeh0HHfPeL2fMXK6z0s8ecKs9frCuLJvndBg==",
      "dev": true,
      "dependencies": {
        "punycode": "^2.1.0"
      }
    },
    "node_modules/util-deprecate": {
      "version": "1.0.2",
      "resolved": "https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz",
      "integrity": "sha512-EPD5q1uXyFxJpCrLnCc1nHnq3gOa6DZBocAIiI2TaSCA7VCJ1UJDMagCzIkXNsUYfD1daK//LTEQ8xiIbrHtcw==",
      "dev": true
    },
    "node_modules/vite": {
      "version": "5.4.8",
      "resolved": "https://registry.npmjs.org/vite/-/vite-5.4.8.tgz",
      "integrity": "sha512-FqrItQ4DT1NC4zCUqMB4c4AZORMKIa0m8/URVCZ77OZ/QSNeJ54bU1vrFADbDsuwfIPcgknRkmqakQcgnL4GiQ==",
      "dev": true,
      "dependencies": {
        "esbuild": "^0.21.3",
        "postcss": "^8.4.43",
        "rollup": "^4.20.0"
      },
      "bin": {
        "vite": "bin/vite.js"
      },
      "engines": {
        "node": "^18.0.0 || >=20.0.0"
      },
      "funding": {
        "url": "https://github.com/vitejs/vite?sponsor=1"
      },
      "optionalDependencies": {
        "fsevents": "~2.3.3"
      },
      "peerDependencies": {
        "@types/node": "^18.0.0 || >=20.0.0",
        "less": "*",
        "lightningcss": "^1.21.0",
        "sass": "*",
        "sass-embedded": "*",
        "stylus": "*",
        "sugarss": "*",
        "terser": "^5.4.0"
      },
      "peerDependenciesMeta": {
        "@types/node": {
          "optional": true
        },
        "less": {
          "optional": true
        },
        "lightningcss": {
          "optional": true
        },
        "sass": {
          "optional": true
        },
        "sass-embedded": {
          "optional": true
        },
        "stylus": {
          "optional": true
        },
        "sugarss": {
          "optional": true
        },
        "terser": {
          "optional": true
        }
      }
    },
    "node_modules/webidl-conversions": {
      "version": "3.0.1",
      "resolved": "https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz",
      "integrity": "sha512-2JAn3z8AR6rjK8Sm8orRC0h/bcl/DqL7tRPdGZ4I1CjdF+EaMLmYxBHyXuKL849eucPFhvBoxMsflfOb8kxaeQ=="
    },
    "node_modules/whatwg-url": {
      "version": "5.0.0",
      "resolved": "https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz",
      "integrity": "sha512-saE57nupxk6v3HY35+jzBwYa0rKSy0XR8JSxZPwgLr7ys0IBzhGviA1/TUGJLmSVqs8pb9AnvICXEuOHLprYTw==",
      "dependencies": {
        "tr46": "~0.0.3",
        "webidl-conversions": "^3.0.0"
      }
    },
    "node_modules/which": {
      "version": "2.0.2",
      "resolved": "https://registry.npmjs.org/which/-/which-2.0.2.tgz",
      "integrity": "sha512-BLI3Tl1TW3Pvl70l3yq3Y64i+awpwXqsGBYWkkqMtnbXgrMD+yj7rhW0kuEDxzJaYXGjEW5ogapKNMEKNMjibA==",
      "dev": true,
      "dependencies": {
        "isexe": "^2.0.0"
      },
      "bin": {
        "node-which": "bin/node-which"
      },
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/word-wrap": {
      "version": "1.2.5",
      "resolved": "https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.5.tgz",
      "integrity": "sha512-BN22B5eaMMI9UMtjrGd5g5eCYPpCPDUy0FJXbYsaT5zYxjFOckS53SQDE3pWkVoWpHXVb3BrYcEN4Twa55B5cA==",
      "dev": true,
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/wrap-ansi": {
      "version": "8.1.0",
      "resolved": "https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-8.1.0.tgz",
      "integrity": "sha512-si7QWI6zUMq56bESFvagtmzMdGOtoxfR+Sez11Mobfc7tm+VkUckk9bW2UeffTGVUbOksxmSw0AA2gs8g71NCQ==",
      "dev": true,
      "dependencies": {
        "ansi-styles": "^6.1.0",
        "string-width": "^5.0.1",
        "strip-ansi": "^7.0.1"
      },
      "engines": {
        "node": ">=12"
      },
      "funding": {
        "url": "https://github.com/chalk/wrap-ansi?sponsor=1"
      }
    },
    "node_modules/wrap-ansi-cjs": {
      "name": "wrap-ansi",
      "version": "7.0.0",
      "resolved": "https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz",
      "integrity": "sha512-YVGIj2kamLSTxw6NsZjoBxfSwsn0ycdesmc4p+Q21c5zPuZ1pl+NfxVdxPtdHvmNVOQ6XSYG4AUtyt/Fi7D16Q==",
      "dev": true,
      "dependencies": {
        "ansi-styles": "^4.0.0",
        "string-width": "^4.1.0",
        "strip-ansi": "^6.0.0"
      },
      "engines": {
        "node": ">=10"
      },
      "funding": {
        "url": "https://github.com/chalk/wrap-ansi?sponsor=1"
      }
    },
    "node_modules/wrap-ansi-cjs/node_modules/ansi-regex": {
      "version": "5.0.1",
      "resolved": "https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz",
      "integrity": "sha512-quJQXlTSUGL2LH9SUXo8VwsY4soanhgo6LNSm84E1LBcE8s3O0wpdiRzyR9z/ZZJMlMWv37qOOb9pdJlMUEKFQ==",
      "dev": true,
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/wrap-ansi-cjs/node_modules/ansi-styles": {
      "version": "4.3.0",
      "resolved": "https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz",
      "integrity": "sha512-zbB9rCJAT1rbjiVDb2hqKFHNYLxgtk8NURxZ3IZwD3F6NtxbXZQCnnSi1Lkx+IDohdPlFp222wVALIheZJQSEg==",
      "dev": true,
      "dependencies": {
        "color-convert": "^2.0.1"
      },
      "engines": {
        "node": ">=8"
      },
      "funding": {
        "url": "https://github.com/chalk/ansi-styles?sponsor=1"
      }
    },
    "node_modules/wrap-ansi-cjs/node_modules/color-convert": {
      "version": "2.0.1",
      "resolved": "https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz",
      "integrity": "sha512-RRECPsj7iu/xb5oKYcsFHSppFNnsj/52OVTRKb4zP5onXwVF3zVmmToNcOfGC+CRDpfK/U584fMg38ZHCaElKQ==",
      "dev": true,
      "dependencies": {
        "color-name": "~1.1.4"
      },
      "engines": {
        "node": ">=7.0.0"
      }
    },
    "node_modules/wrap-ansi-cjs/node_modules/color-name": {
      "version": "1.1.4",
      "resolved": "https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz",
      "integrity": "sha512-dOy+3AuW3a2wNbZHIuMZpTcgjGuLU/uBL/ubcZF9OXbDo8ff4O8yVp5Bf0efS8uEoYo5q4Fx7dY9OgQGXgAsQA==",
      "dev": true
    },
    "node_modules/wrap-ansi-cjs/node_modules/emoji-regex": {
      "version": "8.0.0",
      "resolved": "https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz",
      "integrity": "sha512-MSjYzcWNOA0ewAHpz0MxpYFvwg6yjy1NG3xteoqz644VCo/RPgnr1/GGt+ic3iJTzQ8Eu3TdM14SawnVUmGE6A==",
      "dev": true
    },
    "node_modules/wrap-ansi-cjs/node_modules/string-width": {
      "version": "4.2.3",
      "resolved": "https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz",
      "integrity": "sha512-wKyQRQpjJ0sIp62ErSZdGsjMJWsap5oRNihHhu6G7JVO/9jIB6UyevL+tXuOqrng8j/cxKTWyWUwvSTriiZz/g==",
      "dev": true,
      "dependencies": {
        "emoji-regex": "^8.0.0",
        "is-fullwidth-code-point": "^3.0.0",
        "strip-ansi": "^6.0.1"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/wrap-ansi-cjs/node_modules/strip-ansi": {
      "version": "6.0.1",
      "resolved": "https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz",
      "integrity": "sha512-Y38VPSHcqkFrCpFnQ9vuSXmquuv5oXOKpGeT6aGrr3o3Gc9AlVa6JBfUSOCnbxGGZF+/0ooI7KrPuUSztUdU5A==",
      "dev": true,
      "dependencies": {
        "ansi-regex": "^5.0.1"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/wrap-ansi/node_modules/ansi-styles": {
      "version": "6.2.1",
      "resolved": "https://registry.npmjs.org/ansi-styles/-/ansi-styles-6.2.1.tgz",
      "integrity": "sha512-bN798gFfQX+viw3R7yrGWRqnrN2oRkEkUjjl4JNn4E8GxxbjtG3FbrEIIY3l8/hrwUwIeCZvi4QuOTP4MErVug==",
      "dev": true,
      "engines": {
        "node": ">=12"
      },
      "funding": {
        "url": "https://github.com/chalk/ansi-styles?sponsor=1"
      }
    },
    "node_modules/ws": {
      "version": "8.18.3",
      "resolved": "https://registry.npmjs.org/ws/-/ws-8.18.3.tgz",
      "integrity": "sha512-PEIGCY5tSlUt50cqyMXfCzX+oOPqN0vuGqWzbcJ2xvnkzkq46oOpz7dQaTDBdfICb4N14+GARUDw2XV2N4tvzg==",
      "engines": {
        "node": ">=10.0.0"
      },
      "peerDependencies": {
        "bufferutil": "^4.0.1",
        "utf-8-validate": ">=5.0.2"
      },
      "peerDependenciesMeta": {
        "bufferutil": {
          "optional": true
        },
        "utf-8-validate": {
          "optional": true
        }
      }
    },
    "node_modules/yallist": {
      "version": "3.1.1",
      "resolved": "https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz",
      "integrity": "sha512-a4UGQaWPH59mOXUYnAG2ewncQS4i4F43Tv3JoAM+s2VDAmS9NsK8GpDMLrCHPksFT7h3K6TOoUNn2pb7RoXx4g==",
      "dev": true
    },
    "node_modules/yaml": {
      "version": "2.5.1",
      "resolved": "https://registry.npmjs.org/yaml/-/yaml-2.5.1.tgz",
      "integrity": "sha512-bLQOjaX/ADgQ20isPJRvF0iRUHIxVhYvr53Of7wGcWlO2jvtUlH5m87DsmulFVxRpNLOnI4tB6p/oh8D7kpn9Q==",
      "dev": true,
      "bin": {
        "yaml": "bin.mjs"
      },
      "engines": {
        "node": ">= 14"
      }
    },
    "node_modules/yocto-queue": {
      "version": "0.1.0",
      "resolved": "https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz",
      "integrity": "sha512-rVksvsnNCdJ/ohGc6xgPwyN8eheCxsiLM8mxuE/t/mOVqJewPuO1miLpTHQiRgTKCLexL4MeAFVagts7HmNZ2Q==",
      "dev": true,
      "engines": {
        "node": ">=10"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    }
  }
}

```

----------------------------------------

### File: package.json
```json
{
  "name": "vite-react-typescript-starter",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "lint": "eslint .",
    "preview": "vite preview",
    "typecheck": "tsc --noEmit -p tsconfig.app.json"
  },
  "dependencies": {
    "@supabase/supabase-js": "^2.57.4",
    "@types/leaflet": "^1.9.21",
    "axios": "^1.17.0",
    "leaflet": "^1.9.4",
    "lucide-react": "^0.344.0",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-leaflet": "^5.0.0",
    "react-router-dom": "^7.17.0"
  },
  "devDependencies": {
    "@eslint/js": "^9.9.1",
    "@types/react": "^18.3.5",
    "@types/react-dom": "^18.3.0",
    "@vitejs/plugin-react": "^4.3.1",
    "autoprefixer": "^10.4.18",
    "eslint": "^9.9.1",
    "eslint-plugin-react-hooks": "^5.1.0-rc.0",
    "eslint-plugin-react-refresh": "^0.4.11",
    "globals": "^15.9.0",
    "postcss": "^8.4.35",
    "tailwindcss": "^3.4.1",
    "typescript": "^5.5.3",
    "typescript-eslint": "^8.3.0",
    "vite": "^5.4.2"
  }
}

```

----------------------------------------

### File: postcss.config.js
```js
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};

```

----------------------------------------

### File: tailwind.config.js
```js
/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          100: '#dbeafe',
          200: '#bfdbfe',
          300: '#93c5fd',
          400: '#60a5fa',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
          800: '#1e40af',
          900: '#1e3a8a',
          950: '#172554',
        },
        accent: {
          50: '#f0fdf4',
          100: '#dcfce7',
          200: '#bbf7d0',
          300: '#86efac',
          400: '#4ade80',
          500: '#22c55e',
          600: '#16a34a',
          700: '#15803d',
          800: '#166534',
          900: '#14532d',
        },
      },
      backdropBlur: {
        xs: '2px',
      },
      animation: {
        'fade-in': 'fadeIn 0.3s ease-in-out',
        'slide-up': 'slideUp 0.3s ease-out',
        'slide-down': 'slideDown 0.3s ease-out',
        'scale-in': 'scaleIn 0.2s ease-out',
        'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        slideDown: {
          '0%': { transform: 'translateY(-10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        scaleIn: {
          '0%': { transform: 'scale(0.95)', opacity: '0' },
          '100%': { transform: 'scale(1)', opacity: '1' },
        },
      },
    },
  },
  plugins: [],
};

```

----------------------------------------

### File: tsconfig.app.json
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,

    /* Bundler mode */
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "isolatedModules": true,
    "moduleDetection": "force",
    "noEmit": true,
    "jsx": "react-jsx",

    /* Linting */
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src"]
}

```

----------------------------------------

### File: tsconfig.json
```json
{
  "files": [],
  "references": [
    { "path": "./tsconfig.app.json" },
    { "path": "./tsconfig.node.json" }
  ]
}

```

----------------------------------------

### File: tsconfig.node.json
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["ES2023"],
    "module": "ESNext",
    "skipLibCheck": true,

    /* Bundler mode */
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "isolatedModules": true,
    "moduleDetection": "force",
    "noEmit": true,

    /* Linting */
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["vite.config.ts"]
}

```

----------------------------------------

### File: vite.config.ts
```ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  optimizeDeps: {
    exclude: ['lucide-react'],
  },
});

```

----------------------------------------

### File: .bolt\config.json
```json
{
  "template": "bolt-vite-react-ts"
}

```

----------------------------------------

### File: backend\manage.py
```py
#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys


def main():
    """Run administrative tasks."""
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'chitty_backend.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
    execute_from_command_line(sys.argv)


if __name__ == '__main__':
    main()

```

----------------------------------------

### File: backend\api\admin.py
```py
from django.contrib import admin

from .models import (
    ChitPlan,
    Customer,
    Employee,
    HomeAddress,
    Subscription,
    WorkAddress,
)


@admin.register(Employee)
class EmployeeAdmin(admin.ModelAdmin):
    list_display = ('employee_id', 'user', 'role')
    list_filter = ('role',)
    search_fields = ('employee_id', 'user__username', 'user__first_name', 'user__last_name')


@admin.register(Customer)
class CustomerAdmin(admin.ModelAdmin):
    list_display = ('customer_id', 'full_name', 'mobile_number', 'created_by', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('customer_id', 'full_name', 'mobile_number', 'email')


class AddressAdmin(admin.ModelAdmin):
    list_display = ('customer', 'village', 'district', 'pincode')
    search_fields = ('customer__customer_id', 'customer__full_name', 'village', 'district')


@admin.register(HomeAddress)
class HomeAddressAdmin(AddressAdmin):
    pass


@admin.register(WorkAddress)
class WorkAddressAdmin(AddressAdmin):
    pass


@admin.register(ChitPlan)
class ChitPlanAdmin(admin.ModelAdmin):
    list_display = (
        'plan_code',
        'chit_name',
        'total_amount',
        'monthly_payment',
        'is_active',
        'created_at',
    )
    list_filter = ('is_active',)
    search_fields = ('plan_code', 'chit_name')


@admin.register(Subscription)
class SubscriptionAdmin(admin.ModelAdmin):
    list_display = (
        'customer',
        'chit_plan',
        'payment_status',
        'subscription_status',
        'joined_date',
    )
    list_filter = ('payment_status', 'subscription_status', 'joined_date')
    search_fields = ('customer__customer_id', 'customer__full_name', 'chit_plan__plan_code')

```

----------------------------------------

### File: backend\api\apps.py
```py
from django.apps import AppConfig


class ApiConfig(AppConfig):
    name = 'api'

```

----------------------------------------

### File: backend\api\models.py
```py
from django.conf import settings
from django.db import models


def _next_sequential_code(prefix, model, field_name, start=1001):
    """Generate the next ID like CUST-1001 or EMP-1001."""
    codes = model.objects.values_list(field_name, flat=True)
    max_num = start - 1
    for code in codes:
        if not code or not code.startswith(f'{prefix}-'):
            continue
        try:
            max_num = max(max_num, int(code.split('-', 1)[1]))
        except (IndexError, ValueError):
            continue
    return f'{prefix}-{max_num + 1}'


class Employee(models.Model):
    class Role(models.TextChoices):
        ADMIN = 'admin', 'Admin'
        FIELD_AGENT = 'field_agent', 'Field Agent'

    employee_id = models.CharField(max_length=20, unique=True, editable=False)
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='employee_profile',
    )
    role = models.CharField(max_length=20, choices=Role.choices)

    phone_number = models.CharField(
        max_length=15,
        blank=True,
    )

    class Meta:
        ordering = ['employee_id']

    def __str__(self):
        return f'{self.employee_id} — {self.user.get_full_name() or self.user.username} ({self.get_role_display()})'

    def save(self, *args, **kwargs):
        if not self.employee_id:
            self.employee_id = _next_sequential_code('EMP', Employee, 'employee_id')
        super().save(*args, **kwargs)


class Customer(models.Model):
    
    customer_id = models.CharField(max_length=20, unique=True, editable=False)
    full_name = models.CharField(max_length=255)
    mobile_number = models.CharField(max_length=15)
    alternate_number = models.CharField(max_length=15, blank=True)
    email = models.EmailField(blank=True)
    customer_type = models.CharField(
    max_length=100,
    default="Customer",
)
    approval_status = models.CharField(
    max_length=20,
    default="Pending",
)

    edit_enabled = models.BooleanField(
    default=True,
)
    created_by = models.ForeignKey(
        Employee,
        on_delete=models.PROTECT,
        related_name='customers_created',
    )
    created_at = models.DateTimeField(auto_now_add=True)
    customer_photo = models.ImageField(
    upload_to='customers/',
    blank=True,
    null=True
)
    address_proof = models.ImageField(
    upload_to='customers/',
    blank=True,
    null=True
)
    id_proof = models.ImageField(
    upload_to='customers/',
    blank=True,
    null=True
)
    @property
    def kyc_status(self):
        if (
            self.customer_photo and
            self.address_proof and
            self.id_proof
        ):
            return "Completed"

        return "Pending"

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.customer_id} — {self.full_name}'

    def save(self, *args, **kwargs):
        if not self.customer_id:
            self.customer_id = _next_sequential_code('CUST', Customer, 'customer_id')
        super().save(*args, **kwargs)


class AddressMixin(models.Model):
    house_name = models.CharField(max_length=255, blank=True)
    building_name = models.CharField(max_length=255, blank=True)
    landmark = models.CharField(max_length=255, blank=True)
    village = models.CharField(max_length=255, blank=True)
    taluk = models.CharField(max_length=255, blank=True)
    district = models.CharField(max_length=255, blank=True)
    state = models.CharField(max_length=255, blank=True)
    pincode = models.CharField(max_length=10, blank=True)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    google_maps_link = models.URLField(max_length=500, blank=True)
    address_photo = models.ImageField(upload_to='addresses/', blank=True)

    class Meta:
        abstract = True

    def _build_google_maps_link(self):
        if self.latitude is not None and self.longitude is not None:
            return f'https://www.google.com/maps?q={self.latitude},{self.longitude}'
        return ''

    def save(self, *args, **kwargs):
        self.google_maps_link = self._build_google_maps_link()
        super().save(*args, **kwargs)


class HomeAddress(AddressMixin):
    customer = models.OneToOneField(
        Customer,
        on_delete=models.CASCADE,
        related_name='home_address',
    )

    def __str__(self):
        parts = [p for p in (self.house_name, self.village, self.district) if p]
        label = ', '.join(parts) if parts else 'No address details'
        return f'Home — {self.customer.customer_id}: {label}'
class CurrentAddress(AddressMixin):
    customer = models.OneToOneField(
        Customer,
        on_delete=models.CASCADE,
        related_name='current_address',
    )

    def __str__(self):
        parts = [
            p for p in (
                self.house_name,
                self.village,
                self.district,
            ) if p
        ]
        label = ', '.join(parts) if parts else 'No address details'
        return f'Current — {self.customer.customer_id}: {label}'


class WorkAddress(AddressMixin):
    customer = models.OneToOneField(
        Customer,
        on_delete=models.CASCADE,
        related_name='work_address',
    )

    def __str__(self):
        parts = [p for p in (self.building_name, self.village, self.district) if p]
        label = ', '.join(parts) if parts else 'No address details'
        return f'Work — {self.customer.customer_id}: {label}'


class ChitPlan(models.Model):
    plan_code = models.CharField(max_length=50, unique=True)
    chit_name = models.CharField(max_length=255)
    total_amount = models.DecimalField(max_digits=12, decimal_places=2)
    number_of_installments = models.PositiveIntegerField()
    monthly_payment = models.DecimalField(max_digits=12, decimal_places=2)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['plan_code']

    def __str__(self):
        return f'{self.plan_code} — {self.chit_name}'


class Subscription(models.Model):
    class PaymentStatus(models.TextChoices):
        PENDING = 'pending', 'Pending'
        PARTIAL = 'partial', 'Partial'
        PAID = 'paid', 'Paid'
        OVERDUE = 'overdue', 'Overdue'

    class SubscriptionStatus(models.TextChoices):
        ACTIVE = 'active', 'Active'
        COMPLETED = 'completed', 'Completed'
        CANCELLED = 'cancelled', 'Cancelled'
        SUSPENDED = 'suspended', 'Suspended'

    customer = models.ForeignKey(
        Customer,
        on_delete=models.CASCADE,
        related_name='subscriptions',
    )
    chit_plan = models.ForeignKey(
        ChitPlan,
        on_delete=models.PROTECT,
        related_name='subscriptions',
    )
    payment_status = models.CharField(
        max_length=20,
        choices=PaymentStatus.choices,
        default=PaymentStatus.PENDING,
    )
    subscription_status = models.CharField(
        max_length=20,
        choices=SubscriptionStatus.choices,
        default=SubscriptionStatus.ACTIVE,
    )
    joined_date = models.DateField()

    class Meta:
        ordering = ['-joined_date']
        constraints = [
            models.UniqueConstraint(
                fields=['customer', 'chit_plan'],
                name='unique_customer_chit_plan',
            ),
        ]

    def __str__(self):
        return f'{self.customer.customer_id} → {self.chit_plan.plan_code} ({self.get_subscription_status_display()})'

```

----------------------------------------

### File: backend\api\permissions.py
```py
from rest_framework.permissions import SAFE_METHODS, BasePermission, IsAuthenticated

from .models import Employee


def employee_permissions(*extra):
    """Base API permissions: authenticated, active user with employee profile."""
    return [IsAuthenticated, IsActiveUser, IsEmployee, *extra]


def get_employee(user):
    if not user or not user.is_authenticated:
        return None
    return getattr(user, 'employee_profile', None)


def is_admin(user):
    employee = get_employee(user)
    return employee is not None and employee.role == Employee.Role.ADMIN


class IsActiveUser(BasePermission):
    """Deny API access to inactive Django users."""

    message = 'User account is disabled.'

    def has_permission(self, request, view):
        return (
            request.user
            and request.user.is_authenticated
            and request.user.is_active
        )


class IsAdminEmployee(BasePermission):
    """Only Admin role employees."""

    message = 'Admin access required.'

    def has_permission(self, request, view):
        return is_admin(request.user)


class IsEmployee(BasePermission):
    """User must have a linked Employee profile."""

    message = 'Employee profile required.'

    def has_permission(self, request, view):
        return get_employee(request.user) is not None


class IsAdminOrFieldAgent(BasePermission):
    """Admin or Field Agent employees."""

    message = 'Employee access required.'

    def has_permission(self, request, view):
        employee = get_employee(request.user)
        return employee is not None and employee.role in (
            Employee.Role.ADMIN,
            Employee.Role.FIELD_AGENT,
        )


class IsAdminOrOwnCustomer(BasePermission):
    """
    Admins: full access.
    Field Agents: create allowed; object access only for customers they created.
    """

    message = 'You do not have permission to access this customer.'

    def has_permission(self, request, view):
        if not get_employee(request.user):
            return False
        if request.method in SAFE_METHODS or request.method == 'POST':
            return is_admin(request.user) or get_employee(request.user).role == Employee.Role.FIELD_AGENT
        return True

    def has_object_permission(self, request, view, obj):
        if is_admin(request.user):
            return True
        employee = get_employee(request.user)
        return employee is not None and obj.created_by_id == employee.id


class IsAdminOrOwnCustomerAddress(BasePermission):
    """Address access follows parent customer ownership."""

    message = 'You do not have permission to access this address.'

    def has_permission(self, request, view):
        return get_employee(request.user) is not None

    def has_object_permission(self, request, view, obj):
        if is_admin(request.user):
            return True
        employee = get_employee(request.user)
        return employee is not None and obj.customer.created_by_id == employee.id


class IsAdminOrOwnCustomerSubscription(BasePermission):
    """Subscription access follows customer ownership for Field Agents."""

    message = 'You do not have permission to access this subscription.'

    def has_permission(self, request, view):
        employee = get_employee(request.user)
        if not employee:
            return False
        if request.method == 'POST':
            return employee.role in (Employee.Role.ADMIN, Employee.Role.FIELD_AGENT)
        return True

    def has_object_permission(self, request, view, obj):
        if is_admin(request.user):
            return True
        employee = get_employee(request.user)
        return employee is not None and obj.customer.created_by_id == employee.id

```

----------------------------------------

### File: backend\api\serializers.py
```py
from django.contrib.auth import get_user_model
from rest_framework import serializers
from rest_framework.exceptions import AuthenticationFailed
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
import json
from .models import (
    ChitPlan,
    Customer,
    Employee,
    HomeAddress,
    Subscription,
    WorkAddress,
    CurrentAddress,
)
from .permissions import get_employee, is_admin

User = get_user_model()


class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        data = super().validate(attrs)
        user = self.user

        if not user.is_active:
            raise AuthenticationFailed('User account is disabled.')

        employee = get_employee(user)
        if employee is None:
            raise AuthenticationFailed('No employee profile associated with this account.')

        data['employee_id'] = employee.employee_id
        data['role'] = employee.role
        data['role_display'] = employee.get_role_display()
        return data

    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        employee = get_employee(user)
        if employee:
            token['employee_id'] = employee.employee_id
            token['role'] = employee.role
        return token

class EmployeeSerializer(serializers.ModelSerializer):
    username = serializers.CharField(
    write_only=True,
    required=False,
)
    password = serializers.CharField(
    write_only=True,
    required=False,
)
    email = serializers.EmailField(
    write_only=True,
    required=False,
)

    full_name = serializers.CharField(
    write_only=True,
    required=False,
)
    phone_number = serializers.CharField(
    required=False,
    allow_blank=True,
)
    username_display = serializers.CharField(
    source='user.username',
    read_only=True,
)

    email_display = serializers.EmailField(
    source='user.email',
    read_only=True,
)
    customer_count = serializers.SerializerMethodField()
    is_active = serializers.BooleanField(
        source='user.is_active',
        read_only=True,

    )
    full_name_display = serializers.SerializerMethodField()
    class Meta:
        model = Employee
        fields = [
            'id',
            'employee_id',
            'full_name',
            'username',
            'email',
            'password',
            'phone_number',
            'role',
            'username_display',
            'email_display',
            'customer_count',
            'is_active',
            'full_name_display',
        ]
        read_only_fields = ['employee_id']

    def create(self, validated_data):

        username = validated_data.pop('username')
        password = validated_data.pop('password')
        email = validated_data.pop('email')
        full_name = validated_data.pop('full_name')
        phone_number = validated_data.pop(
    'phone_number',
    '',
)
        names = full_name.split(' ', 1)

        first_name = names[0]
        last_name = names[1] if len(names) > 1 else ''

        user = User.objects.create_user(
            username=username,
            email=email,
            password=password,
            first_name=first_name,
            last_name=last_name,
        )

        employee = Employee.objects.create(
    user=user,
    phone_number=phone_number,
    **validated_data,
)
        return employee
    def get_customer_count(self, obj):
        return obj.customers_created.count()
    def get_full_name(self, obj):

        return (
            f'{obj.user.first_name} '
            f'{obj.user.last_name}'
    ).strip()
    def update(self, instance, validated_data):

        full_name = validated_data.pop(
            'full_name',
            None,
    )   
        print("FULL NAME:", full_name)

        email = validated_data.pop(
            'email',
            None,
    )

        phone_number = validated_data.pop(
            'phone_number',
            None,
    )

        if full_name:

            names = full_name.split(' ', 1)

            instance.user.first_name = names[0]

            instance.user.last_name = (
                names[1]
                if len(names) > 1
                else ''
        )

        if email:
            instance.user.email = email

        instance.user.save()
 
        if phone_number is not None:
            instance.phone_number = phone_number

        instance.role = validated_data.get(
            'role',
            instance.role,
    )

        instance.save()
        return instance
    def get_full_name_display(self, obj):
        return (
            f"{obj.user.first_name} {obj.user.last_name}"
    ).strip()


class HomeAddressSerializer(serializers.ModelSerializer):
    google_maps_link = serializers.URLField(read_only=True)

    class Meta:
        model = HomeAddress
        fields = [
            'house_name',
    'building_name',
    'landmark',
    'village',
    'taluk',
    'district',
    'state',
    'pincode',
    'latitude',
    'longitude',
    'google_maps_link',
    'address_photo',
        ]

class CurrentAddressSerializer(serializers.ModelSerializer):
    google_maps_link = serializers.URLField(read_only=True)

    class Meta:
        model = CurrentAddress
        fields = [
            'house_name',
            'building_name',
            'landmark',
            'village',
            'taluk',
            'district',
            'state',
            'pincode',
            'latitude',
            'longitude',
            'google_maps_link',
            'address_photo',
        ]
class WorkAddressSerializer(serializers.ModelSerializer):
    google_maps_link = serializers.URLField(read_only=True)

    class Meta:
        model = WorkAddress
        fields = [
            'house_name',
    'building_name',
    'landmark',
    'village',
    'taluk',
    'district',
    'state',
    'pincode',
    'latitude',
    'longitude',
    'google_maps_link',
    'address_photo',
        ]


class CustomerSerializer(serializers.ModelSerializer):

    created_by_name = serializers.CharField(
        source='created_by.__str__',
        read_only=True,
    )
    kyc_status = serializers.ReadOnlyField()
    home_address = HomeAddressSerializer(
        required=False,
    )
    current_address = CurrentAddressSerializer(
    required=False,
)

    work_address = WorkAddressSerializer(
        required=False,
    )

    class Meta:
        model = Customer
        fields = [
            'id',
            'customer_id',
            'full_name',
            'mobile_number',
            'alternate_number',
            'email',
            'customer_type',
            'approval_status',
            'edit_enabled',
            'created_by',
            'created_by_name',
            'created_at',
            'home_address',
            'current_address',
            'work_address',
            'customer_photo',
            'address_proof',
            'id_proof',
            'kyc_status',
        ]
        read_only_fields = [
            'customer_id',
            'created_by',
            'created_at',
        ]

    def create(self, validated_data):

        request = self.context.get('request')

        home_address_data = None
        current_address_data = None
        work_address_data = None

        if request:

            home_address_raw = request.data.get('home_address')
            current_address_raw = request.data.get('current_address')
            work_address_raw = request.data.get('work_address')

            if home_address_raw:
                home_address_data = json.loads(home_address_raw)
            if current_address_raw:
                current_address_data = json.loads(current_address_raw)

            if work_address_raw:
                work_address_data = json.loads(work_address_raw)

            customer = Customer.objects.create(**validated_data)

        if home_address_data:
            home = HomeAddress.objects.create(
                customer=customer,
                **home_address_data,
            )

            if request.FILES.get("home_address_proof"):
                home.address_photo = request.FILES["home_address_proof"]
                home.save()

        if current_address_data:
            print("CURRENT ADDRESS DATA:", current_address_data)
            current = CurrentAddress.objects.create(
                customer=customer,
                **current_address_data,
            )
            print("CURRENT ADDRESS CREATED:", current.id)
            if request.FILES.get("current_address_proof"):
                current.address_photo = request.FILES["current_address_proof"]
                current.save()

        if work_address_data:
            work = WorkAddress.objects.create(
                customer=customer,
                **work_address_data,
            )

            if request.FILES.get("work_address_proof"):
                work.address_photo = request.FILES["work_address_proof"]
                work.save()

        return customer

    def update(self, instance, validated_data):

        home_address_data = validated_data.pop(
            'home_address',
            None,
        )
        current_address_data = validated_data.pop(
    'current_address',
    None,
)

        work_address_data = validated_data.pop(
            'work_address',
            None,
        )

        for attr, value in validated_data.items():
            setattr(instance, attr, value)

        instance.save()

        if home_address_data:

            home_address, created = HomeAddress.objects.get_or_create(
                customer=instance,
            )

            for attr, value in home_address_data.items():
                setattr(home_address, attr, value)
            if self.context['request'].FILES.get("home_address_proof"):
               home_address.address_photo = self.context['request'].FILES["home_address_proof"]

            home_address.save()
        if current_address_data:

            current_address, created = CurrentAddress.objects.get_or_create(
                    customer=instance,
    )

            for attr, value in current_address_data.items():
                 setattr(current_address, attr, value)
            if self.context['request'].FILES.get("current_address_proof"):
               current_address.address_photo = self.context['request'].FILES["current_address_proof"]


            current_address.save()

        if work_address_data:

            work_address, created = WorkAddress.objects.get_or_create(
                customer=instance,
            )

            for attr, value in work_address_data.items():
                setattr(work_address, attr, value)
            if self.context['request'].FILES.get("work_address_proof"):
               work_address.address_photo = self.context['request'].FILES["work_address_proof"]

            work_address.save()

        return instance

    
class ChitPlanSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChitPlan
        fields = [
            'id',
            'plan_code',
            'chit_name',
            'total_amount',
            'number_of_installments',
            'monthly_payment',
            'is_active',
            'created_at',
        ]
        read_only_fields = ['created_at']

class SubscriptionSerializer(serializers.ModelSerializer):
    customer_name = serializers.CharField(source='customer.full_name', read_only=True)
    customer_id_display = serializers.CharField(source='customer.customer_id', read_only=True)
    chit_plan_name = serializers.CharField(source='chit_plan.chit_name', read_only=True)
    chit_plan_code = serializers.CharField(source='chit_plan.plan_code', read_only=True)

    class Meta:
        model = Subscription
        fields = [
            'id',
            'customer',
            'customer_id_display',
            'customer_name',
            'chit_plan',
            'chit_plan_code',
            'chit_plan_name',
            'payment_status',
            'subscription_status',
            'joined_date',
        ]

    def validate_customer(self, customer):
        request = self.context.get('request')
        if not request:
            return customer

        employee = get_employee(request.user)
        if employee and employee.role == Employee.Role.FIELD_AGENT:
            if customer.created_by_id != employee.id:
                raise serializers.ValidationError(
                    'You can only create subscriptions for your own customers.'
                )
        return customer

    def validate_chit_plan(self, chit_plan):
        if not chit_plan.is_active and not is_admin(self.context['request'].user):
            raise serializers.ValidationError('This chit plan is not active.')
        return chit_plan


class DashboardRecentCustomerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Customer
        fields = ['id', 'customer_id', 'full_name', 'created_at', 'kyc_status',]


class DashboardRecentSubscriptionSerializer(serializers.ModelSerializer):
    customer_name = serializers.CharField(source='customer.full_name', read_only=True)
    chit_plan_name = serializers.CharField(source='chit_plan.chit_name', read_only=True)
    monthly_payment = serializers.DecimalField(
        source='chit_plan.monthly_payment',
        max_digits=12,
        decimal_places=2,
        read_only=True,
    )

    class Meta:
        model = Subscription
        fields = [
            'id',
            'customer_name',
            'chit_plan_name',
            'monthly_payment',
            'payment_status',
        ]

```

----------------------------------------

### File: backend\api\tests.py
```py
from django.test import TestCase

# Create your tests here.

```

----------------------------------------

### File: backend\api\urls.py
```py
from django.urls import include, path
from rest_framework.routers import DefaultRouter
from .views import (
    ChitPlanViewSet,
    CustomTokenObtainPairView,
    CustomTokenRefreshView,
    CustomerViewSet,
    DashboardRecentCustomersAPIView,
    DashboardRecentSubscriptionsAPIView,
    DashboardStatsAPIView,
    EmployeeViewSet,
    HomeAddressViewSet,
    SubscriptionViewSet,
    CurrentAddressViewSet,
    WorkAddressViewSet,
    AgentDashboardAPIView,
    reports_summary,
    monthly_collections,
    plan_distribution,
    payment_overview,
)

    


router = DefaultRouter()
router.register('employees', EmployeeViewSet, basename='employee')
router.register('customers', CustomerViewSet, basename='customer')
router.register('home-addresses', HomeAddressViewSet, basename='home-address')
router.register(
    'current-addresses',
    CurrentAddressViewSet,
    basename='current-address',
)
router.register('work-addresses', WorkAddressViewSet, basename='work-address')
router.register('chit-plans', ChitPlanViewSet, basename='chit-plan')
router.register('subscriptions', SubscriptionViewSet, basename='subscription')

urlpatterns = [
    path('token/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', CustomTokenRefreshView.as_view(), name='token_refresh'),
    path('dashboard/stats/', DashboardStatsAPIView.as_view(), name='dashboard-stats'),
    path(
    'agent-dashboard/',
    AgentDashboardAPIView.as_view(),
    name='agent-dashboard',
),
    path(
        'dashboard/recent-customers/',
        DashboardRecentCustomersAPIView.as_view(),
        name='dashboard-recent-customers',
    ),
    path(
        'dashboard/recent-subscriptions/',
        DashboardRecentSubscriptionsAPIView.as_view(),
        name='dashboard-recent-subscriptions',
    ),
    path('reports/summary/', reports_summary),

    path('reports/monthly-collections/', monthly_collections),

    path('reports/plan-distribution/', plan_distribution),

    path('reports/payment-overview/', payment_overview),

    path('', include(router.urls)),
]

```

----------------------------------------

### File: backend\api\views.py
```py
from datetime import timedelta
from rest_framework.decorators import action
from rest_framework.response import Response
from django.db.models import Sum, Count
from django.utils import timezone
from rest_framework import filters, viewsets
from rest_framework.exceptions import PermissionDenied
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response

from rest_framework.decorators import action
from rest_framework.response import Response
from .models import (
    ChitPlan,
    Customer,
    Employee,
    HomeAddress,
    Subscription,
    CurrentAddress,
    WorkAddress,
)
from .permissions import (
    IsAdminEmployee,
    IsAdminOrFieldAgent,
    IsAdminOrOwnCustomer,
    IsAdminOrOwnCustomerAddress,
    IsAdminOrOwnCustomerSubscription,
    employee_permissions,
    get_employee,
    is_admin,
)
from .serializers import (
    ChitPlanSerializer,
    CustomTokenObtainPairSerializer,
    CustomerSerializer,
    DashboardRecentCustomerSerializer,
    DashboardRecentSubscriptionSerializer,
    EmployeeSerializer,
    HomeAddressSerializer,
    SubscriptionSerializer,
    CurrentAddressSerializer,
    WorkAddressSerializer,
)


class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer
    permission_classes = [AllowAny]


class CustomTokenRefreshView(TokenRefreshView):
    permission_classes = [AllowAny]


def _scoped_customers_queryset(user):
    queryset = Customer.objects.all()
    employee = get_employee(user)
    if not employee:
        return queryset.none()
    if not is_admin(user):
        queryset = queryset.filter(created_by=employee)
    return queryset


def _scoped_subscriptions_queryset(user):
    queryset = Subscription.objects.all()
    employee = get_employee(user)
    if not employee:
        return queryset.none()
    if not is_admin(user):
        queryset = queryset.filter(customer__created_by=employee)
    return queryset


class DashboardStatsAPIView(APIView):
    permission_classes = employee_permissions(IsAdminOrFieldAgent)

    def get(self, request):
        employee = get_employee(request.user)
        if not employee:
            return Response({
                'total_customers': 0,
                'active_subscriptions': 0,
                'monthly_collections_total': 0,
                'pending_payments': 0,
                'active_chit_plans': 0,
                'recent_onboardings': 0,
            })

        customers_qs = _scoped_customers_queryset(request.user)
        subscriptions_qs = _scoped_subscriptions_queryset(request.user)

        active_subscriptions_qs = subscriptions_qs.filter(
            subscription_status=Subscription.SubscriptionStatus.ACTIVE,
        )

        monthly_collections = active_subscriptions_qs.aggregate(
            total=Sum('chit_plan__monthly_payment'),
        )['total'] or 0

        pending_payments = subscriptions_qs.filter(
            payment_status__in=[
                Subscription.PaymentStatus.PENDING,
                Subscription.PaymentStatus.OVERDUE,
            ],
        ).count()

        seven_days_ago = timezone.now() - timedelta(days=7)
        recent_onboardings = customers_qs.filter(created_at__gte=seven_days_ago).count()

        return Response({
            'total_customers': customers_qs.count(),
            'active_subscriptions': active_subscriptions_qs.count(),
            'monthly_collections_total': float(monthly_collections),
            'pending_payments': pending_payments,
            'active_chit_plans': ChitPlan.objects.filter(is_active=True).count(),
            'recent_onboardings': recent_onboardings,
        })


class DashboardRecentCustomersAPIView(APIView):
    permission_classes = employee_permissions(IsAdminOrFieldAgent)

    def get(self, request):
        customers = _scoped_customers_queryset(request.user).order_by('-created_at')[:5]
        serializer = DashboardRecentCustomerSerializer(customers, many=True)
        return Response(serializer.data)


class DashboardRecentSubscriptionsAPIView(APIView):
    permission_classes = employee_permissions(IsAdminOrFieldAgent)

    def get(self, request):
        subscriptions = (
            _scoped_subscriptions_queryset(request.user)
            .filter(subscription_status=Subscription.SubscriptionStatus.ACTIVE)
            .select_related('customer', 'chit_plan')
            .order_by('-joined_date')[:5]
        )
        serializer = DashboardRecentSubscriptionSerializer(subscriptions, many=True)
        return Response(serializer.data)


class EmployeeViewSet(viewsets.ModelViewSet):
    queryset = Employee.objects.select_related('user').all()
    serializer_class = EmployeeSerializer
    permission_classes = employee_permissions(IsAdminEmployee)
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = [
        'employee_id',
        'user__username',
        'user__first_name',
        'user__last_name'
    ]
    ordering_fields = ['employee_id', 'role']

    @action(detail=True, methods=['post'])
    def toggle_status(self, request, pk=None):

        employee = self.get_object()

        employee.user.is_active = (
            not employee.user.is_active
        )

        employee.user.save()

        return Response({
            'success': True,
            'is_active': employee.user.is_active,
        })


class CustomerViewSet(viewsets.ModelViewSet):
    serializer_class = CustomerSerializer
    permission_classes = employee_permissions(IsAdminOrFieldAgent, IsAdminOrOwnCustomer)
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['customer_id', 'full_name', 'mobile_number']
    ordering_fields = ['created_at', 'customer_id', 'full_name']

    def get_queryset(self):
        queryset = Customer.objects.select_related(
    'created_by',
    'created_by__user',
    'home_address',
    'current_address',
    'work_address',
).prefetch_related(
    'subscriptions__chit_plan',
)

        employee = get_employee(self.request.user)
        if not employee:
            return queryset.none()
        if not is_admin(self.request.user):
            queryset = queryset.filter(created_by=employee)

        chit_plan = self.request.query_params.get('chit_plan')
        if chit_plan:
            queryset = queryset.filter(subscriptions__chit_plan_id=chit_plan)

        chit_plan_code = self.request.query_params.get('chit_plan_code')
        if chit_plan_code:
            queryset = queryset.filter(
                subscriptions__chit_plan__plan_code__icontains=chit_plan_code
            )

        return queryset.distinct()

    def perform_create(self, serializer):
        serializer.save(created_by=get_employee(self.request.user))
    
    @action(detail=True, methods=['post'])
    def approve(self, request, pk=None):

        customer = self.get_object()

        customer.approval_status = "Approved"
        customer.edit_enabled = False

        customer.save()

        return Response({
            "message": "Customer approved successfully"
    })

class HomeAddressViewSet(viewsets.ModelViewSet):
    serializer_class = HomeAddressSerializer
    permission_classes = employee_permissions(IsAdminOrOwnCustomerAddress)
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = [
        'customer__customer_id',
        'customer__full_name',
        'village',
        'district',
        'pincode',
    ]

    def get_queryset(self):
        queryset = HomeAddress.objects.select_related('customer', 'customer__created_by')
        employee = get_employee(self.request.user)
        if not employee:
            return queryset.none()
        if not is_admin(self.request.user):
            queryset = queryset.filter(customer__created_by=employee)

        customer_id = self.request.query_params.get('customer')
        if customer_id:
            queryset = queryset.filter(customer_id=customer_id)

        return queryset

    def perform_create(self, serializer):
        customer = serializer.validated_data['customer']
        employee = get_employee(self.request.user)
        if not is_admin(self.request.user) and customer.created_by_id != employee.id:
            raise PermissionDenied('You can only add addresses for your own customers.')
        serializer.save()

class CurrentAddressViewSet(viewsets.ModelViewSet):
    serializer_class = CurrentAddressSerializer
    permission_classes = employee_permissions(IsAdminOrOwnCustomerAddress)
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = [
        'customer__customer_id',
        'customer__full_name',
        'village',
        'district',
        'pincode',
    ]

    def get_queryset(self):
        queryset = CurrentAddress.objects.select_related('customer', 'customer__created_by')
        employee = get_employee(self.request.user)
        if not employee:
            return queryset.none()
        if not is_admin(self.request.user):
            queryset = queryset.filter(customer__created_by=employee)

        customer_id = self.request.query_params.get('customer')
        if customer_id:
            queryset = queryset.filter(customer_id=customer_id)

        return queryset

    def perform_create(self, serializer):
        customer = serializer.validated_data['customer']
        employee = get_employee(self.request.user)
        if not is_admin(self.request.user) and customer.created_by_id != employee.id:
            raise PermissionDenied('You can only add addresses for your own customers.')
        serializer.save()

class WorkAddressViewSet(viewsets.ModelViewSet):
    serializer_class = WorkAddressSerializer
    permission_classes = employee_permissions(IsAdminOrOwnCustomerAddress)
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = [
        'customer__customer_id',
        'customer__full_name',
        'village',
        'district',
        'pincode',
    ]

    def get_queryset(self):
        queryset = WorkAddress.objects.select_related('customer', 'customer__created_by')
        employee = get_employee(self.request.user)
        if not employee:
            return queryset.none()
        if not is_admin(self.request.user):
            queryset = queryset.filter(customer__created_by=employee)

        customer_id = self.request.query_params.get('customer')
        if customer_id:
            queryset = queryset.filter(customer_id=customer_id)

        return queryset

    def perform_create(self, serializer):
        customer = serializer.validated_data['customer']
        employee = get_employee(self.request.user)
        if not is_admin(self.request.user) and customer.created_by_id != employee.id:
            raise PermissionDenied('You can only add addresses for your own customers.')
        serializer.save()


class ChitPlanViewSet(viewsets.ModelViewSet):
    serializer_class = ChitPlanSerializer
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['plan_code', 'chit_name']
    ordering_fields = ['plan_code', 'created_at', 'total_amount']

    def get_permissions(self):
        if self.action in ('create', 'update', 'partial_update', 'destroy'):
            return [permission() for permission in employee_permissions(IsAdminEmployee)]
        return [permission() for permission in employee_permissions()]

    def get_queryset(self):
        queryset = ChitPlan.objects.all()
        if not is_admin(self.request.user):
            queryset = queryset.filter(is_active=True)

        is_active = self.request.query_params.get('is_active')
        if is_active is not None and is_admin(self.request.user):
            queryset = queryset.filter(is_active=is_active.lower() in ('true', '1', 'yes'))

        return queryset


class SubscriptionViewSet(viewsets.ModelViewSet):
    serializer_class = SubscriptionSerializer
    permission_classes = employee_permissions(
        IsAdminOrFieldAgent,
        IsAdminOrOwnCustomerSubscription,
    )
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = [
        'customer__customer_id',
        'customer__full_name',
        'customer__mobile_number',
        'chit_plan__plan_code',
        'chit_plan__chit_name',
    ]
    ordering_fields = ['joined_date', 'payment_status', 'subscription_status']

    def get_queryset(self):
        queryset = Subscription.objects.select_related(
            'customer',
            'chit_plan',
            'customer__created_by',
        )

        employee = get_employee(self.request.user)
        if not employee:
            return queryset.none()
        if not is_admin(self.request.user):
            queryset = queryset.filter(customer__created_by=employee)

        customer = self.request.query_params.get('customer')
        if customer:
            queryset = queryset.filter(customer_id=customer)

        chit_plan = self.request.query_params.get('chit_plan')
        if chit_plan:
            queryset = queryset.filter(chit_plan_id=chit_plan)

        chit_plan_code = self.request.query_params.get('chit_plan_code')
        if chit_plan_code:
            queryset = queryset.filter(chit_plan__plan_code__icontains=chit_plan_code)

        payment_status = self.request.query_params.get('payment_status')
        if payment_status:
            queryset = queryset.filter(payment_status=payment_status)

        subscription_status = self.request.query_params.get('subscription_status')
        if subscription_status:
            queryset = queryset.filter(subscription_status=subscription_status)

        return queryset
    
@api_view(['GET'])
@permission_classes(employee_permissions(IsAdminOrFieldAgent))
def reports_summary(request):

    subscriptions = _scoped_subscriptions_queryset(request.user)

    total_collections = subscriptions.filter(
        payment_status=Subscription.PaymentStatus.PAID
    ).aggregate(
        total=Sum('chit_plan__monthly_payment')
    )['total'] or 0

    new_customers = _scoped_customers_queryset(request.user).count()

    active_chitties = subscriptions.filter(
        subscription_status=Subscription.SubscriptionStatus.ACTIVE
    ).count()

    pending_payments = subscriptions.filter(
        payment_status=Subscription.PaymentStatus.PENDING
    ).count()

    return Response({
        "total_collections": float(total_collections),
        "new_customers": new_customers,
        "active_chitties": active_chitties,
        "pending_payments": pending_payments,
    })


@api_view(['GET'])
@permission_classes(employee_permissions(IsAdminOrFieldAgent))
def monthly_collections(request):

    data = [
        {"month": "Jan", "amount": 12000},
        {"month": "Feb", "amount": 18000},
        {"month": "Mar", "amount": 25000},
        {"month": "Apr", "amount": 21000},
        {"month": "May", "amount": 30000},
        {"month": "Jun", "amount": 28000},
    ]

    return Response(data)


@api_view(['GET'])
@permission_classes(employee_permissions(IsAdminOrFieldAgent))
def plan_distribution(request):

    plans = ChitPlan.objects.annotate(
        customer_count=Count('subscriptions')
    )

    result = []

    for plan in plans:
        result.append({
            "plan": plan.chit_name,
            "customers": plan.customer_count
        })

    return Response(result)


@api_view(['GET'])
@permission_classes(employee_permissions(IsAdminOrFieldAgent))
def payment_overview(request):

    subscriptions = _scoped_subscriptions_queryset(request.user)

    paid = subscriptions.filter(
        payment_status=Subscription.PaymentStatus.PAID
    ).count()

    pending = subscriptions.filter(
        payment_status=Subscription.PaymentStatus.PENDING
    ).count()

    overdue = subscriptions.filter(
        payment_status=Subscription.PaymentStatus.OVERDUE
    ).count()

    return Response({
        "paid": paid,
        "pending": pending,
        "overdue": overdue
    })
class AgentDashboardAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        employee = Employee.objects.get(
            user=request.user,
        )

        customers = Customer.objects.filter(
            created_by=employee
        )

        subscriptions = Subscription.objects.filter(
            customer__created_by=employee,
            subscription_status='active',
        )

        recent_customers = customers.order_by(
            '-created_at'
        )[:5]


        recent_data = []

        for customer in recent_customers:
            latest_sub = customer.subscriptions.first()

            recent_data.append({
                'name': customer.full_name,
                'phone': customer.mobile_number,
                'plan': (
                    latest_sub.chit_plan.chit_name
                    if latest_sub
                    else '-'
                ),
            })

        return Response({
            'total_customers': customers.count(),
            'active_subscriptions':
                subscriptions.count(),
            'recent_customers':
                recent_data,
        })
```

----------------------------------------

### File: backend\api\__init__.py
```py

```

----------------------------------------

### File: backend\api\migrations\0001_initial.py
```py
# Generated by Django 6.0.3 on 2026-06-07 06:28

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='ChitPlan',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('plan_code', models.CharField(max_length=50, unique=True)),
                ('chit_name', models.CharField(max_length=255)),
                ('total_amount', models.DecimalField(decimal_places=2, max_digits=12)),
                ('number_of_installments', models.PositiveIntegerField()),
                ('monthly_payment', models.DecimalField(decimal_places=2, max_digits=12)),
                ('is_active', models.BooleanField(default=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
            ],
            options={
                'ordering': ['plan_code'],
            },
        ),
        migrations.CreateModel(
            name='Employee',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('employee_id', models.CharField(editable=False, max_length=20, unique=True)),
                ('role', models.CharField(choices=[('admin', 'Admin'), ('field_agent', 'Field Agent')], max_length=20)),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='employee_profile', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'ordering': ['employee_id'],
            },
        ),
        migrations.CreateModel(
            name='Customer',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('customer_id', models.CharField(editable=False, max_length=20, unique=True)),
                ('full_name', models.CharField(max_length=255)),
                ('mobile_number', models.CharField(max_length=15)),
                ('alternate_number', models.CharField(blank=True, max_length=15)),
                ('email', models.EmailField(blank=True, max_length=254)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('created_by', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, related_name='customers_created', to='api.employee')),
            ],
            options={
                'ordering': ['-created_at'],
            },
        ),
        migrations.CreateModel(
            name='HomeAddress',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('house_name', models.CharField(blank=True, max_length=255)),
                ('building_name', models.CharField(blank=True, max_length=255)),
                ('landmark', models.CharField(blank=True, max_length=255)),
                ('village', models.CharField(blank=True, max_length=255)),
                ('taluk', models.CharField(blank=True, max_length=255)),
                ('district', models.CharField(blank=True, max_length=255)),
                ('state', models.CharField(blank=True, max_length=255)),
                ('pincode', models.CharField(blank=True, max_length=10)),
                ('latitude', models.DecimalField(blank=True, decimal_places=6, max_digits=9, null=True)),
                ('longitude', models.DecimalField(blank=True, decimal_places=6, max_digits=9, null=True)),
                ('google_maps_link', models.URLField(blank=True, max_length=500)),
                ('address_photo', models.ImageField(blank=True, upload_to='addresses/')),
                ('customer', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='home_address', to='api.customer')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='WorkAddress',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('house_name', models.CharField(blank=True, max_length=255)),
                ('building_name', models.CharField(blank=True, max_length=255)),
                ('landmark', models.CharField(blank=True, max_length=255)),
                ('village', models.CharField(blank=True, max_length=255)),
                ('taluk', models.CharField(blank=True, max_length=255)),
                ('district', models.CharField(blank=True, max_length=255)),
                ('state', models.CharField(blank=True, max_length=255)),
                ('pincode', models.CharField(blank=True, max_length=10)),
                ('latitude', models.DecimalField(blank=True, decimal_places=6, max_digits=9, null=True)),
                ('longitude', models.DecimalField(blank=True, decimal_places=6, max_digits=9, null=True)),
                ('google_maps_link', models.URLField(blank=True, max_length=500)),
                ('address_photo', models.ImageField(blank=True, upload_to='addresses/')),
                ('customer', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='work_address', to='api.customer')),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Subscription',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('payment_status', models.CharField(choices=[('pending', 'Pending'), ('partial', 'Partial'), ('paid', 'Paid'), ('overdue', 'Overdue')], default='pending', max_length=20)),
                ('subscription_status', models.CharField(choices=[('active', 'Active'), ('completed', 'Completed'), ('cancelled', 'Cancelled'), ('suspended', 'Suspended')], default='active', max_length=20)),
                ('joined_date', models.DateField()),
                ('chit_plan', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, related_name='subscriptions', to='api.chitplan')),
                ('customer', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='subscriptions', to='api.customer')),
            ],
            options={
                'ordering': ['-joined_date'],
                'constraints': [models.UniqueConstraint(fields=('customer', 'chit_plan'), name='unique_customer_chit_plan')],
            },
        ),
    ]

```

----------------------------------------

### File: backend\api\migrations\0002_customer_address_proof_customer_customer_photo_and_more.py
```py
# Generated by Django 6.0.3 on 2026-06-14 16:48

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='customer',
            name='address_proof',
            field=models.ImageField(blank=True, null=True, upload_to='customers/'),
        ),
        migrations.AddField(
            model_name='customer',
            name='customer_photo',
            field=models.ImageField(blank=True, null=True, upload_to='customers/'),
        ),
        migrations.AddField(
            model_name='customer',
            name='id_proof',
            field=models.ImageField(blank=True, null=True, upload_to='customers/'),
        ),
    ]

```

----------------------------------------

### File: backend\api\migrations\0003_employee_phone_number.py
```py
# Generated by Django 6.0.3 on 2026-06-19 06:11

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_customer_address_proof_customer_customer_photo_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='employee',
            name='phone_number',
            field=models.CharField(blank=True, max_length=15),
        ),
    ]

```

----------------------------------------

### File: backend\api\migrations\0004_currentaddress.py
```py
# Generated by Django 6.0.3 on 2026-07-07 06:31

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0003_employee_phone_number'),
    ]

    operations = [
        migrations.CreateModel(
            name='CurrentAddress',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('house_name', models.CharField(blank=True, max_length=255)),
                ('building_name', models.CharField(blank=True, max_length=255)),
                ('landmark', models.CharField(blank=True, max_length=255)),
                ('village', models.CharField(blank=True, max_length=255)),
                ('taluk', models.CharField(blank=True, max_length=255)),
                ('district', models.CharField(blank=True, max_length=255)),
                ('state', models.CharField(blank=True, max_length=255)),
                ('pincode', models.CharField(blank=True, max_length=10)),
                ('latitude', models.DecimalField(blank=True, decimal_places=6, max_digits=9, null=True)),
                ('longitude', models.DecimalField(blank=True, decimal_places=6, max_digits=9, null=True)),
                ('google_maps_link', models.URLField(blank=True, max_length=500)),
                ('address_photo', models.ImageField(blank=True, upload_to='addresses/')),
                ('customer', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='current_address', to='api.customer')),
            ],
            options={
                'abstract': False,
            },
        ),
    ]

```

----------------------------------------

### File: backend\api\migrations\0005_customer_customer_type.py
```py
# Generated by Django 6.0.3 on 2026-07-14 05:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0004_currentaddress'),
    ]

    operations = [
        migrations.AddField(
            model_name='customer',
            name='customer_type',
            field=models.CharField(default='Customer', max_length=100),
        ),
    ]

```

----------------------------------------

### File: backend\api\migrations\0006_customer_approval_status_customer_edit_enabled.py
```py
# Generated by Django 6.0.3 on 2026-07-16 04:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0005_customer_customer_type'),
    ]

    operations = [
        migrations.AddField(
            model_name='customer',
            name='approval_status',
            field=models.CharField(default='Pending', max_length=20),
        ),
        migrations.AddField(
            model_name='customer',
            name='edit_enabled',
            field=models.BooleanField(default=True),
        ),
    ]

```

----------------------------------------

### File: backend\api\migrations\__init__.py
```py

```

----------------------------------------

### File: backend\chitty_backend\asgi.py
```py
"""
ASGI config for chitty_backend project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/6.0/howto/deployment/asgi/
"""

import os

from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'chitty_backend.settings')

application = get_asgi_application()

```

----------------------------------------

### File: backend\chitty_backend\settings.py
```py
"""
Django settings for chitty_backend project.

Generated by 'django-admin startproject' using Django 6.0.3.

For more information on this file, see
https://docs.djangoproject.com/en/6.0/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/6.0/ref/settings/
"""

from datetime import timedelta
from pathlib import Path

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/6.0/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-=7%tu8c#7^w!$&(ksd-damqoah59yhyw8y22&q1)qe#38=+9qr'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['*']


# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'corsheaders',
    'rest_framework_simplejwt',
    'api',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'chitty_backend.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'chitty_backend.wsgi.application'


# Database
# https://docs.djangoproject.com/en/6.0/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}


# Password validation
# https://docs.djangoproject.com/en/6.0/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/6.0/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/6.0/howto/static-files/

STATIC_URL = 'static/'

MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'

# CORS
CORS_ALLOWED_ORIGINS = [
    'http://localhost:5173',
]

# Django REST Framework
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
        'api.permissions.IsActiveUser',
    ),
}

# SimpleJWT
SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=60),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=7),
    'ROTATE_REFRESH_TOKENS': False,
    'BLACKLIST_AFTER_ROTATION': False,
    'AUTH_HEADER_TYPES': ('Bearer',),
}

```

----------------------------------------

### File: backend\chitty_backend\urls.py
```py
"""
URL configuration for chitty_backend project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/6.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('api.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

```

----------------------------------------

### File: backend\chitty_backend\wsgi.py
```py
"""
WSGI config for chitty_backend project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/6.0/howto/deployment/wsgi/
"""

import os

from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'chitty_backend.settings')

application = get_wsgi_application()

```

----------------------------------------

### File: backend\chitty_backend\__init__.py
```py

```

----------------------------------------

### File: chitty_mobile\analysis_options.yaml
```yaml
# This file configures the analyzer, which statically analyzes Dart code to
# check for errors, warnings, and lints.
#
# The issues identified by the analyzer are surfaced in the UI of Dart-enabled
# IDEs (https://dart.dev/tools#ides-and-editors). The analyzer can also be
# invoked from the command line by running `flutter analyze`.

# The following line activates a set of recommended lints for Flutter apps,
# packages, and plugins designed to encourage good coding practices.
include: package:flutter_lints/flutter.yaml

linter:
  # The lint rules applied to this project can be customized in the
  # section below to disable rules from the `package:flutter_lints/flutter.yaml`
  # included above or to enable additional rules. A list of all available lints
  # and their documentation is published at https://dart.dev/lints.
  #
  # Instead of disabling a lint rule for the entire project in the
  # section below, it can also be suppressed for a single line of code
  # or a specific dart file by using the `// ignore: name_of_lint` and
  # `// ignore_for_file: name_of_lint` syntax on the line or in the file
  # producing the lint.
  rules:
    # avoid_print: false  # Uncomment to disable the `avoid_print` rule
    # prefer_single_quotes: true  # Uncomment to enable the `prefer_single_quotes` rule

# Additional information about this file can be found at
# https://dart.dev/guides/language/analysis-options

```

----------------------------------------

### File: chitty_mobile\pubspec.yaml
```yaml
name: chitty_mobile
description: "A new Flutter project."
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.0+1

environment:
  sdk: ^3.12.1

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter
  image_picker: ^1.1.2
  cupertino_icons: ^1.0.8
  url_launcher: ^6.3.2
  
  geolocator: ^14.0.2
  permission_handler: ^12.0.3
  http: ^1.2.1
  shared_preferences: ^2.2.2
  google_maps_flutter: ^2.17.1
dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^6.0.0

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/to/resolution-aware-images

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/to/asset-from-package

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/to/font-from-package

```

----------------------------------------

### File: chitty_mobile\lib\main.dart
```dart
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const ChittyApp());
}

class ChittyApp extends StatelessWidget {
  const ChittyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chitty Finance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\agent_dashboard_screen.dart
```dart
import 'package:flutter/material.dart';
import 'agent_subscriptions_screen.dart';
import 'customers_screen.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class AgentDashboardScreen extends StatefulWidget {
  const AgentDashboardScreen({super.key});

  @override
  State<AgentDashboardScreen> createState() =>
      _AgentDashboardScreenState();
}

class _AgentDashboardScreenState
    extends State<AgentDashboardScreen> {

  int totalCustomers = 0;
  int activeSubscriptions = 0;

  List<dynamic> recentCustomers = [];

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final data =
        await AuthService.getAgentDashboard();

    setState(() {
      totalCustomers =
          data['total_customers'] ?? 0;

      activeSubscriptions =
          data['active_subscriptions'] ?? 0;

      recentCustomers =
          data['recent_customers'] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    bool mobile = width < 900;

    return Scaffold(
  backgroundColor: const Color(0xFF020617),

  appBar: mobile
      ? AppBar(
          backgroundColor: const Color(0xFF020617),
          elevation: 0,
          iconTheme:
            const IconThemeData(
           color: Colors.white,
        ),
      )
      : null,

  drawer: mobile
      ? Drawer(
          child: Container(
            color: const Color(0xFF081028),
            child: Column(
              children: [
                const SizedBox(height: 50),

                ListTile(
                  leading: const Icon(Icons.dashboard,
                      color: Colors.white),
                  title: const Text(
                    'Dashboard',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const AgentDashboardScreen(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.people,
                      color: Colors.white),
                  title: const Text(
                    'Customers',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CustomersScreen(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.subscriptions,
                      color: Colors.white),
                  title: const Text(
                    'Subscriptions',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const AgentSubscriptionsScreen(),
                      ),
                    );
                  },
                ),

                const Spacer(),

                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        )
      : null,

  body: Row(

        children: [

          /// SIDEBAR
          if (!mobile)
            Container(

              width: 260,

              padding: const EdgeInsets.all(20),

              decoration: const BoxDecoration(
                color: Color(0xFF081028),
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      Container(

                        padding:
                            const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius:
                              BorderRadius.circular(
                                  18),
                        ),

                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 14),

                      const Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Text(
                            'ChittyFinance',

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          Text(
                            'Agent Panel',

                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  sidebarItem(
                    context,
                    Icons.dashboard,
                    'Dashboard',
                    const AgentDashboardScreen(),
                    true,
                  ),

                  sidebarItem(
                    context,
                    Icons.people,
                    'Customers',
                    const CustomersScreen(),
                    false,
                  ),

                  sidebarItem(
  context,
  Icons.subscriptions,
  'Subscriptions',
  const AgentSubscriptionsScreen(),
  false,
),
                  const Spacer(),

                  SizedBox(

                    width: double.infinity,

                    child: ElevatedButton.icon(

                      onPressed: () {

                        Navigator.pushReplacement(

                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                const LoginScreen(),
                          ),
                        );
                      },

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.redAccent,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),

                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),

                      label: const Text(
                        'Logout',

                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          /// MAIN CONTENT
          Expanded(

            child: SafeArea(

              child: SingleChildScrollView(

                padding: const EdgeInsets.all(24),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// HEADER
                    const Text(

                      'Agent Dashboard',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(

                      'Welcome back, Agent',

                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// STATS
                    GridView.count(

                      shrinkWrap: true,

                      physics:
                          const NeverScrollableScrollPhysics(),

                      crossAxisCount:
                          mobile ? 1 : 2,

                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,

                      childAspectRatio: 2.3,

                      children: [

                        statsCard(
  'Total Customers',
  totalCustomers.toString(),
  Icons.people,
  Colors.blue,
),

statsCard(
  'Active Subscriptions',
  activeSubscriptions.toString(),
  Icons.subscriptions,
  Colors.green,
),
                        
                      ],
                    ),

                    const SizedBox(height: 35),

                    /// RECENT CUSTOMERS
                    sectionTitle(
                      'Recent Customers',
                    ),

                    const SizedBox(height: 20),

                    tableContainer(

                      child: Column(

                        children: [

                          tableRow(
  true,
  'Customer',
  'Phone',
  'Plan',
  '',
),

                          ...recentCustomers.map(
  (customer) => tableRow(
    false,
    customer['name'] ?? '',
    customer['phone'] ?? '',
    customer['plan'] ?? '',
    '',
  ),
),
                        ],
                      ),
                    ),

                    
                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sidebarItem(

    BuildContext context,

    IconData icon,

    String title,

    Widget page,

    bool active,
  ) {

    return GestureDetector(

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(
            builder: (_) => page,
          ),
        );
      },

      child: Container(

        margin:
            const EdgeInsets.only(bottom: 14),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),

        decoration: BoxDecoration(

          color: active
              ? const Color(0xFF1E3A8A)
              : Colors.transparent,

          borderRadius:
              BorderRadius.circular(16),
        ),

        child: Row(

          children: [

            Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),

            const SizedBox(width: 14),

            Text(

              title,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statsCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {

    return Container(

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Row(

        children: [

          Container(

            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: color.withOpacity(0.15),

              borderRadius:
                  BorderRadius.circular(18),
            ),

            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),

          const SizedBox(width: 20),

          Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Text(
                value,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                title,

                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {

    return Text(

      title,

      style: const TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget tableContainer({
    required Widget child,
  }) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: child,
    );
  }

  Widget tableRow(

    bool header,

    String c1,

    String c2,

    String c3,

    String c4,
  ) {

    final style = TextStyle(

      color:
          header ? Colors.white : Colors.white70,

      fontWeight:
          header ? FontWeight.bold : FontWeight.normal,
    );

    return Padding(

      padding:
          const EdgeInsets.symmetric(vertical: 14),

      child: Row(

        children: [

          Expanded(
            child: Text(c1, style: style),
          ),

          Expanded(
            child: Text(c2, style: style),
          ),

          Expanded(
            child: Text(c3, style: style),
          ),

          Expanded(
            child: Text(c4, style: style),
          ),
        ],
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\agent_subscriptions_screen.dart
```dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/subscription_dialog.dart';
class AgentSubscriptionsScreen extends StatefulWidget {
  const AgentSubscriptionsScreen({super.key});

  @override
  State<AgentSubscriptionsScreen> createState() =>
      _AgentSubscriptionsScreenState();
}

class _AgentSubscriptionsScreenState extends State<AgentSubscriptionsScreen> {
  List<dynamic> subscriptions = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSubscriptions();
  }

  Future<void> _loadSubscriptions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedSubscriptions = await AuthService.getSubscriptions();
      print('Subscriptions: $fetchedSubscriptions');
      setState(() {
        subscriptions = fetchedSubscriptions;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load subscriptions';
        isLoading = false;
      });
    }
  }

  List<DataRow> _buildSubscriptionRows() {
    return subscriptions.map((subscription) {
      final paymentStatus =
          subscription['payment_status']?.toString() ?? '';
      final actionButton = paymentStatus.toLowerCase() == 'pending'
          ? ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Collect'),
            )
          : OutlinedButton(
              onPressed: () {},
              child: const Text('View'),
            );

      return DataRow(cells: [
        DataCell(
          Text(subscription['customer_name']?.toString() ?? ''),
        ),
        DataCell(
          Text(subscription['chit_plan_name']?.toString() ?? ''),
        ),
        DataCell(
          Text(subscription['chit_plan_code']?.toString() ?? ''),
        ),
        DataCell(
          Text(subscription['subscription_status']?.toString() ?? ''),
        ),
        DataCell(actionButton),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),

      appBar: AppBar(
        backgroundColor: const Color(0xFF020617),
        elevation: 0,
        title: const Text(
          'My Subscriptions',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              'My Subscriptions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Manage customer collections',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
  onPressed: () async {
    final result = await showDialog(
      context: context,
      builder: (_) => const SubscriptionDialog(),
    );

    if (result == true) {
      await _loadSubscriptions();
    }
  },
  icon: const Icon(Icons.add),
  label: const Text('Enroll Customer'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    padding: const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 16,
    ),
  ),
),

            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Text(
                    'Assigned Subscriptions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (errorMessage != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  else if (subscriptions.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'No subscriptions found',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        dataTextStyle: const TextStyle(
                          color: Colors.white70,
                        ),
                        columns: const [
                          DataColumn(label: Text('Customer')),
                          DataColumn(label: Text('Plan')),
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: _buildSubscriptionRows(),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 40),

          ],
        ),
      ),
    );
  }

  Widget buildCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color: Colors.blue,
            size: 32,
          ),

          const SizedBox(height: 15),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\chit_plans_screen.dart
```dart
import 'package:flutter/material.dart';

import '../widgets/sidebar.dart';
import '../widgets/chit_plan_dialog.dart';

class ChitPlansScreen extends StatefulWidget {
  const ChitPlansScreen({super.key});

  @override
  State<ChitPlansScreen> createState() =>
      _ChitPlansScreenState();
}

class _ChitPlansScreenState
    extends State<ChitPlansScreen> {

  final List<Map<String, dynamic>> plans = [

    {
      'name': 'Gold Savings',
      'code': 'GS101',
      'amount': '₹ 1,00,000',
      'months': '20 months',
      'monthly': '₹ 5,000',
      'status': 'Active',
    },

    {
      'name': 'Premium Plus',
      'code': 'PP202',
      'amount': '₹ 2,50,000',
      'months': '25 months',
      'monthly': '₹ 10,000',
      'status': 'Paused',
    },
  ];

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    bool mobile = width < 900;

    return Scaffold(

      backgroundColor: const Color(0xFF020617),

      body: Row(

        children: [

          if (!mobile)
            const Sidebar(),

          Expanded(

            child: SafeArea(

              child: SingleChildScrollView(

                padding: const EdgeInsets.all(24),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// TOP BAR
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            const Text(
                              'Chit Plans',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Manage savings schemes',

                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        ElevatedButton.icon(

                          onPressed: () {

                            showDialog(

                              context: context,

                              builder: (_) =>
                                  const ChitPlanDialog(),
                            );
                          },

                          style:
                              ElevatedButton.styleFrom(

                            backgroundColor:
                                Colors.blue,

                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      18),
                            ),
                          ),

                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),

                          label: const Text(
                            'Create Plan',

                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// MAIN CONTAINER
                    Container(

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius:
                            BorderRadius.circular(24),
                      ),

                      child: Column(

                        children: [

                          /// SEARCH
                          TextField(

                            style: const TextStyle(
                              color: Colors.white,
                            ),

                            decoration: InputDecoration(

                              hintText:
                                  'Search plans...',

                              hintStyle:
                                  const TextStyle(
                                color: Colors.white54,
                              ),

                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white54,
                              ),

                              filled: true,
                              fillColor:
                                  const Color(
                                      0xFF0F172A),

                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(16),

                                borderSide:
                                    BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          /// TABLE / MOBILE CARDS
                          mobile
                              ? Column(
                                  children:
                                      plans.map((plan) {

                                    return mobileCard(
                                        plan);
                                  }).toList(),
                                )

                              : SingleChildScrollView(
                                  scrollDirection:
                                      Axis.horizontal,

                                  child: DataTable(

                                    columnSpacing: 45,

                                    headingTextStyle:
                                        const TextStyle(
                                      color:
                                          Colors.white70,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),

                                    dataTextStyle:
                                        const TextStyle(
                                      color: Colors.white,
                                    ),

                                    columns: const [

                                      DataColumn(
                                        label: Text(
                                            'PLAN NAME'),
                                      ),

                                      DataColumn(
                                        label: Text(
                                            'TOTAL AMOUNT'),
                                      ),

                                      DataColumn(
                                        label: Text(
                                            'INSTALLMENTS'),
                                      ),

                                      DataColumn(
                                        label: Text(
                                            'MONTHLY PAYMENT'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('STATUS'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('ACTIONS'),
                                      ),
                                    ],

                                    rows: plans.map((p) {

                                      return DataRow(
                                        cells: [

                                          DataCell(
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,

                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,

                                              children: [

                                                Text(
                                                  p['name'],
                                                ),

                                                Text(
                                                  p['code'],

                                                  style:
                                                      const TextStyle(
                                                    color:
                                                        Colors.white54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              p['amount'],
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              p['months'],
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              p['monthly'],

                                              style:
                                                  const TextStyle(
                                                color:
                                                    Colors.green,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                          DataCell(
                                            statusChip(
                                              p['status'],
                                            ),
                                          ),

                                          DataCell(
                                            Row(
                                              children: [

                                                IconButton(

                                                  onPressed:
                                                      () {

                                                    showDialog(

                                                      context:
                                                          context,

                                                      builder:
                                                          (_) =>
                                                              const ChitPlanDialog(),
                                                    );
                                                  },

                                                  icon:
                                                      const Icon(
                                                    Icons.edit,
                                                    color:
                                                        Colors.white70,
                                                  ),
                                                ),

                                                IconButton(
                                                  onPressed:
                                                      () {},

                                                  icon:
                                                      const Icon(
                                                    Icons
                                                        .power_settings_new,
                                                    color:
                                                        Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statusChip(String status) {

    Color color = status == 'Active'
        ? Colors.green
        : Colors.orange;

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        status,

        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget mobileCard(
    Map<String, dynamic> p,
  ) {

    return Container(

      margin: const EdgeInsets.only(bottom: 20),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            p['name'],

            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            p['code'],

            style: const TextStyle(
              color: Colors.white54,
            ),
          ),

          const SizedBox(height: 20),

          infoText(
            'Total Amount',
            p['amount'],
          ),

          infoText(
            'Installments',
            p['months'],
          ),

          infoText(
            'Monthly',
            p['monthly'],
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              statusChip(p['status']),

              const Spacer(),

              IconButton(
                onPressed: () {

                  showDialog(

                    context: context,

                    builder: (_) =>
                        const ChitPlanDialog(),
                  );
                },

                icon: const Icon(
                  Icons.edit,
                  color: Colors.white70,
                ),
              ),

              IconButton(
                onPressed: () {},

                icon: const Icon(
                  Icons.power_settings_new,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoText(
    String title,
    String value,
  ) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        children: [

          Text(
            '$title : ',

            style: const TextStyle(
              color: Colors.white54,
            ),
          ),

          Expanded(
            child: Text(
              value,

              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\customers_screen.dart
```dart
import 'package:flutter/material.dart';
//import 'add_customer_screen.dart';
import '../services/auth_service.dart';
import 'customer_details_screen.dart';
//import 'edit_customer_screen.dart';
import 'add_customer/customer_form_data.dart';
import 'add_customer/add_customer_step1.dart';
class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() =>
      _CustomersScreenState();
}

class _CustomersScreenState
    extends State<CustomersScreen> {

  List customers = [];
  List filteredCustomers = [];

  final searchController =
    TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {

  final data =
      await AuthService.getCustomers();

  print("CUSTOMERS DATA:");
  print(data);
  print("COUNT = ${data.length}");

  setState(() {

    customers = data;
    filteredCustomers = data;
    isLoading = false;
  });
}
  /*Future<void> deleteCustomer(
  int customerId,
) async {

  bool success =
      await AuthService.deleteCustomer(
    customerId,
  );

  if (success) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content: Text(
          'Customer Deleted',
        ),
      ),
    );

    loadCustomers();
  }
}*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),

      appBar: AppBar(
        backgroundColor: const Color(0xFF020617),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// HEADER
              LayoutBuilder(
                builder: (context, constraints) {

                  bool mobile = constraints.maxWidth < 700;

                  return mobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              'Customers',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Manage all customer records',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,

                              child: ElevatedButton.icon(
                                onPressed: () async{

                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AddCustomerStep1(
                                            formData: CustomerFormData(),
                                          ),
                                    ),
                                  );
                                  loadCustomers();
                                },

                                icon: const Icon(Icons.add),

                                label: const Text(
                                  'Add Customer',
                                ),

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )

                      : Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,

                          children: [

                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: const [

                                Text(
                                  'Customers',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 8),

                                Text(
                                  'Manage all customer records',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),

                            ElevatedButton.icon(
                              onPressed: () async{

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AddCustomerStep1(
                                           formData: CustomerFormData(),
                                        ),
                                  ),
                                );
                                loadCustomers();
                              },

                              icon: const Icon(Icons.add),

                              label: const Text(
                                'Add Customer',
                              ),

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ],
                        );
                },
              ),

              const SizedBox(height: 30),

              /// CUSTOMER TABLE CARD
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(24),
                ),

                child: Column(
                  children: [

                    /// SEARCH
                    TextField(
  controller: searchController,

  onChanged: (value) {

    setState(() {

      filteredCustomers = customers.where((customer) {

        final search =
            value.toLowerCase();

        return (customer['full_name'] ?? '')
                .toString()
                .toLowerCase()
                .contains(search) ||

            (customer['customer_id'] ?? '')
                .toString()
                .toLowerCase()
                .contains(search) ||

            (customer['mobile_number'] ?? '')
                .toString()
                .toLowerCase()
                .contains(search);

      }).toList();
    });
  },

  style: const TextStyle(
    color: Colors.white,
  ),

                      decoration: InputDecoration(
                        hintText:
                            'Search by name, ID, or phone...',

                        hintStyle:
                            const TextStyle(color: Colors.white54),

                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white54,
                        ),

                        filled: true,
                        fillColor: const Color(0xFF0F172A),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// TABLE
                    /*SingleChildScrollView(
                      scrollDirection: Axis.horizontal,

                      child: DataTable(

                        headingRowColor:
                            MaterialStateProperty.all(
                          const Color(0xFF1E293B),
                        ),

                        dataRowColor:
                            MaterialStateProperty.all(
                          const Color(0xFF1E293B),
                        ),

                        columns: const [

                          DataColumn(
                            label: Text(
                              'CUSTOMER',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          DataColumn(
                            label: Text(
                              'CONTACT',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          DataColumn(
                            label: Text(
                              'EMAIL',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          DataColumn(
                            label: Text(
                              'LOCATION',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          DataColumn(
                            label: Text(
                              'ACTION',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
rows: filteredCustomers.map<DataRow>((customer)  {

  return DataRow(

    cells: [

      DataCell(
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [

      Text(
        customer['full_name'] ?? '',
        style: const TextStyle(
          color: Colors.white,
        ),
      ),

      const SizedBox(height: 4),

      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: customer['kyc_status'] == 'Completed'
              ? Colors.green
              : Colors.orange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          customer['kyc_status'] ?? 'Pending',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  ),
),

      DataCell(
        Text(
          customer['mobile_number'] ?? '',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      DataCell(
        Text(
          customer['email'] ?? '',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      DataCell(
  Text(
    customer['home_address'] != null
        ? customer['home_address']['district'] ?? '-'
        : '-',
    style: const TextStyle(
      color: Colors.white,
    ),
  ),
),

  DataCell(
  Row(
    mainAxisSize: MainAxisSize.min,
    children: [

      // View
      IconButton(
        icon: const Icon(
          Icons.visibility,
          color: Colors.blue,
        ),
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CustomerDetailsScreen(
                customer: customer,
              ),
            ),
          );
        },
      ),

      // Edit
      IconButton(
        icon: const Icon(
          Icons.edit,
          color: Colors.orange,
        ),
    onPressed: () async {

  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EditCustomerScreen(
        customer: customer,
      ),
    ),
  );

  if (result == true) {
    loadCustomers();
  }
},
      ),

      // Delete
      IconButton(
  icon: const Icon(
    Icons.delete,
    color: Colors.red,
  ),

  onPressed: () async {

    bool? confirm =
        await showDialog<bool>(

      context: context,

      builder: (_) => AlertDialog(

        title: const Text(
          'Delete Customer',
        ),

        content: const Text(
          'Are you sure?',
        ),

        actions: [

          TextButton(
            onPressed: () {

              Navigator.pop(
                context,
                false,
              );
            },

            child: const Text(
              'Cancel',
            ),
          ),

          ElevatedButton(
            onPressed: () {

              Navigator.pop(
                context,
                true,
              );
            },

            child: const Text(
              'Delete',
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {

      deleteCustomer(
        customer['id'],
      );
    }
  },
),
    ],
  ),
),
    ],
  );

}).toList(),
                      ),
                    ),*/
                    Column(
  children: [

    // Header
    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      child: Row(
        children: const [

          Expanded(
            flex: 2,
            child: Text(
              "Customer",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(
              "Contact",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    ),

    const Divider(color: Colors.white24),

    ...filteredCustomers.map((customer) {

      return InkWell(

        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CustomerDetailsScreen(
                    customer: customer,
                  ),
            ),
          );
        },

        child: Column(

          children: [

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 16,
              ),

              child: Row(
  children: [

    Expanded(
      flex: 2,
      child: Text(
        customer['full_name'] ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ),

    Expanded(
      child: Text(
        customer['mobile_number'] ?? '',
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    ),

    const SizedBox(width: 8),

    const Icon(
      Icons.chevron_right,
      color: Colors.white38,
      size: 20,
    ),

  ],
),
            ),

            const Divider(
              color: Colors.white12,
              height: 1,
            ),
          ],
        ),
      );

    }).toList(),

  ],
)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\customer_details_screen.dart
```dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'edit_customer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CustomerDetailsScreen extends StatelessWidget {
   final Map customer;

  const CustomerDetailsScreen({
    super.key,
    required this.customer,
  });
  @override
  Widget build(BuildContext context) {
    print("DETAIL CUSTOMER DATA:");
    //print(customer);

    return Scaffold(
      backgroundColor: const Color(0xFF020617),

      appBar: AppBar(
  backgroundColor: const Color(0xFF020617),

  title: const Text(
    'Customer Details ',
    style: TextStyle(
      color: Colors.white,
    ),
  ),

  actions: [
    FutureBuilder<String?>(
  future: AuthService.getRole(),
  builder: (context, snapshot) {

    if (snapshot.data != "admin") {
      return const SizedBox.shrink();
    }

    if (customer['approval_status'] == "Approved") {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: const Icon(
        Icons.verified,
        color: Colors.green,
      ),
      onPressed: () async {

        final success =
            await AuthService.approveCustomer(
          customer['id'],
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Customer Approved",
              ),
            ),
          );

          Navigator.pop(context, true);
        }
      },
    );
  },
),
     FutureBuilder<String>(
  future: SharedPreferences.getInstance().then(
    (prefs) => prefs.getString('role') ?? '',
  ),
  builder: (context, snapshot) {
    final role = snapshot.data ?? '';

    if (role == 'field_agent' &&
        customer['edit_enabled'] == false) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditCustomerScreen(
              customer: customer,
            ),
          ),
        );

        if (result == true) {
          Navigator.pop(context, true);
        }
      },
    );
  },
),

    IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),

      onPressed: () async {

  final confirm = await showDialog<bool>(

    context: context,

    builder: (context) {

      return AlertDialog(

        title: const Text("Delete Customer"),

        content: const Text(
          "Are you sure you want to delete this customer?",
        ),

        actions: [

          TextButton(

            onPressed: () {

              Navigator.pop(context, false);

            },

            child: const Text("Cancel"),

          ),

          ElevatedButton(

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),

            onPressed: () {

              Navigator.pop(context, true);

            },

            child: const Text("Delete"),

          ),

        ],

      );

    },

  );

  if (confirm != true) return;

  // Delete API call goes here next.
  final success = await AuthService.deleteCustomer(
  customer['id'],
);

if (!context.mounted) return;

if (success) {

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Customer deleted successfully"),
    ),
  );

  Navigator.pop(context, true);

} else {

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Failed to delete customer"),
    ),
  );

}

},
    ),

  ],
),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: ListView(
          children: [

            buildTile(
              'Customer ID',
              customer['customer_id'] ?? '-',
            ),

            buildTile(
              'Full Name',
              customer['full_name'] ?? '-',
            ),

            buildTile(
              'Mobile',
              customer['mobile_number'] ?? '-',
            ),

            buildTile(
              'Alternate Number',
              customer['alternate_number'] ?? '-',
            ),

            buildTile(
              'Email',
              customer['email'] ?? '-',
            ),
            buildTile(
  'Customer Type',
  customer['customer_type'] ?? '-',
),
buildTile(
  'Approval Status',
  customer['approval_status'] ?? '-',
),

buildTile(
  'Edit Status',
  customer['edit_enabled'] == true
      ? 'Enabled'
      : 'Disabled',
),

            buildTile(
              'Created At',
              customer['created_at'] ?? '-',
            ),

            const SizedBox(height: 20),

            const Text(
              'Home Address',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            buildTile(
              'House Name',
              customer['home_address']?['house_name'] ?? '-',
            ),

            buildTile(
              'Village',
              customer['home_address']?['village'] ?? '-',
            ),

            buildTile(
              'Taluk',
              customer['home_address']?['taluk'] ?? '-',
            ),

            buildTile(
              'District',
              customer['home_address']?['district'] ?? '-',
            ),

            buildTile(
              'State',
              customer['home_address']?['state'] ?? '-',
            ),

            buildTile(
              'Pincode',
              customer['home_address']?['pincode'] ?? '-',
            ),
            const SizedBox(height: 20),
const SizedBox(height: 20),

const Text(
  'Current Address',
  style: TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

buildTile(
  'House Name',
  customer['current_address']?['house_name'] ?? '-',
),

buildTile(
  'Building Name',
  customer['current_address']?['building_name'] ?? '-',
),

buildTile(
  'Landmark',
  customer['current_address']?['landmark'] ?? '-',
),

buildTile(
  'Village',
  customer['current_address']?['village'] ?? '-',
),

buildTile(
  'Taluk',
  customer['current_address']?['taluk'] ?? '-',
),

buildTile(
  'District',
  customer['current_address']?['district'] ?? '-',
),

buildTile(
  'State',
  customer['current_address']?['state'] ?? '-',
),

buildTile(
  'Pincode',
  customer['current_address']?['pincode'] ?? '-',
),

buildTile(
  'Google Maps',
  customer['current_address']?['google_maps_link'] ?? '-',
),
const Text(
  'Work Address',
  style: TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

buildTile(
  'Company Name',
  customer['work_address']?['building_name'] ?? '-',
),

buildTile(
  'Office Address',
  customer['work_address']?['house_name'] ?? '-',
),

buildTile(
  'Landmark',
  customer['work_address']?['landmark'] ?? '-',
),

buildTile(
  'Village',
  customer['work_address']?['village'] ?? '-',
),

buildTile(
  'Taluk',
  customer['work_address']?['taluk'] ?? '-',
),

buildTile(
  'District',
  customer['work_address']?['district'] ?? '-',
),

buildTile(
  'State',
  customer['work_address']?['state'] ?? '-',
),

buildTile(
  'Pincode',
  customer['work_address']?['pincode'] ?? '-',
),

buildTile(
  'Google Maps',
  customer['work_address']?['google_maps_link'] ?? '-',
),
const SizedBox(height: 20),

const Text(
  'KYC Documents',
  style: TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

if (customer['customer_photo'] != null)
  Card(
    color: const Color(0xFF1E293B),
    child: Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Customer Photo',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Image.network(
          customer['customer_photo'],
          height: 250,
        ),
        const SizedBox(height: 10),
      ],
    ),
  ),

if (customer['address_proof'] != null)
  Card(
    color: const Color(0xFF1E293B),
    child: Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Address Proof',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Image.network(
          customer['address_proof'],
          height: 250,
        ),
        const SizedBox(height: 10),
      ],
    ),
  ),

if (customer['id_proof'] != null)
  Card(
    color: const Color(0xFF1E293B),
    child: Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'ID Proof',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Image.network(
          customer['id_proof'],
          height: 250,
        ),
        const SizedBox(height: 10),
      ],
    ),
  ),
  if (customer['home_address']?['address_photo'] != null)
  Card(
    color: const Color(0xFF1E293B),
    child: Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Home Address Proof',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Image.network(
          customer['home_address']['address_photo'],
          height: 250,
        ),
        const SizedBox(height: 10),
      ],
    ),
  ),
  if (customer['current_address']?['address_photo'] != null)
  Card(
    color: const Color(0xFF1E293B),
    child: Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Current Address Proof',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Image.network(
          customer['current_address']['address_photo'],
          height: 250,
        ),
        const SizedBox(height: 10),
      ],
    ),
  ),
  if (customer['work_address']?['address_photo'] != null)
  Card(
    color: const Color(0xFF1E293B),
    child: Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Work Address Proof',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Image.network(
          customer['work_address']['address_photo'],
          height: 250,
        ),
        const SizedBox(height: 10),
      ],
    ),
  ),
          ],
        ),
      ),
    );
  }

  Widget buildTile(
    String title,
    String value,
  ) {
    return Card(
      color: const Color(0xFF1E293B),

      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),

        subtitle: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\dashboard_screen.dart
```dart
import 'package:flutter/material.dart';
//import 'add_customer_screen.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/info_container.dart';
import '../widgets/sidebar.dart';
import 'employees_screen.dart';
import 'chit_plans_screen.dart';
import 'reports_screen.dart';
import '../services/dashboard_service.dart';
import '../services/auth_service.dart';
import 'add_customer/add_customer_step1.dart';
import 'add_customer/customer_form_data.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
      Map<String, dynamic>? stats;
     

List recentCustomers = [];
int pendingKycCount = 0;
List recentSubscriptions = [];
bool isLoading = true;

@override
void initState() {
  super.initState();
  loadStats();
  loadDashboard();

}

Future<void> loadStats() async {
  print("LOAD STATS CALLED");
  try {
    final data =
        await DashboardService.getStats();

    setState(() {
      stats = data;
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      isLoading = false;
    });
  }
}
Future<void> loadDashboard() async {
  print("LOAD DASHBOARD CALLED");

  try {

    recentCustomers =
        await AuthService.getRecentCustomers();
    print(recentCustomers.first.keys);

    print('Customers loaded');
    for (var customer in recentCustomers) {
      print(customer);
}

    final count = recentCustomers.where((customer) {

  final status =
      customer['kyc_status']
          ?.toString()
          .trim()
          .toLowerCase();

  print(
    "${customer['full_name']} => '$status'"
  );

  return status == 'pending';

}).length;

    print("==========");
    print("final count = $count");
    print("==========");

    recentSubscriptions =
        await AuthService.getRecentSubscriptions();

    setState(() {

      pendingKycCount = count;

    });
    //print("FINAL COUNT = $pendingKycCount");
  } catch (e) {

    print(e);

  }
}
Widget actionCard(
  BuildContext context,
  String title,
  IconData icon,
  Color color,
  Widget screen,
) {
  return InkWell(
  onTap: () async {

  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => screen,
    ),
  );

  if (result == true) {
    await loadStats();
    await loadDashboard();
  }
},
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
  Widget customerTile(
    String name,
    String id,
    String amount,
  ) {

    return Container(

      margin: const EdgeInsets.only(bottom: 16),

      child: Row(

        children: [

          CircleAvatar(
            backgroundColor: Colors.blue,

            child: Text(
              name[0],
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  id,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget subscriptionTile(
    String plan,
    String amount,
  ) {

    return Container(

      margin: const EdgeInsets.only(bottom: 16),

      child: Row(

        children: [

          CircleAvatar(
            backgroundColor: Colors.purple,

            child: Text(
              plan[0],
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              plan,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
  return const Scaffold(
    backgroundColor: Color(0xFF020617),
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

    final width = MediaQuery.of(context).size.width;

    final isMobile = width < 700;
    final isTablet = width >= 700 && width < 1100;

    return Scaffold(

      backgroundColor: const Color(0xFF020617),

      drawer: isMobile ? const Drawer(
        child: Sidebar(),
      ) : null,

      appBar: isMobile
          ? AppBar(
              backgroundColor: const Color(0xFF081028),
            )
          : null,

      body: Row(

        children: [

          if (!isMobile)
            const Sidebar(),

          Expanded(

            child: Padding(

              padding: const EdgeInsets.all(20),

              child: SingleChildScrollView(

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Row(
  mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
  children: [

    const Text(
      'Dashboard',
      style: TextStyle(
        color: Colors.white,
        fontSize: 34,
        fontWeight: FontWeight.bold,
      ),
    ),

    Stack(
      children: [

        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Pending KYC'),
                content: Text(
                  '$pendingKycCount customer(s) have pending KYC',
                ),
              ),
            );},
        ),

        if (pendingKycCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$pendingKycCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ),
  ],
),

                    const SizedBox(height: 10),

                    const Text(
                      "Welcome back! Here's your overview.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 30),

                    GridView.count(

                      crossAxisCount:
                          isMobile ? 1 : (isTablet ? 2 : 3),

                      shrinkWrap: true,

                      physics:
                          const NeverScrollableScrollPhysics(),

                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,

                      childAspectRatio: isMobile ? 2.2 : 1.4,

                      children: [
                        DashboardCard(
  title: 'Total Customers',
  value: '${stats?['total_customers'] ?? 0}',
  icon: Icons.people,
  color: Colors.blue,
),
                        DashboardCard(
                          title: 'Active Chitties',
                          value: '${stats?['active_subscriptions'] ?? 0}',
                          icon: Icons.account_balance_wallet,
                          color: Colors.green,
                        ),

                        DashboardCard(
                          title: 'Monthly Collection',
                          value: '₹${stats?['monthly_collections_total'] ?? 0}',
                          icon: Icons.currency_rupee,
                          color: Colors.lightBlueAccent,
                        ),

                        DashboardCard(
                          title: 'Pending Payments',
                          value: '${stats?['pending_payments'] ?? 0}',
                          icon: Icons.access_time,
                          color: Colors.orange,
                        ),

                        DashboardCard(
                          title: 'Active Plans',
                          value: '${stats?['active_chit_plans'] ?? 0}',
                          icon: Icons.description,
                          color: Colors.lightGreen,
                        ),

                        DashboardCard(
                          title: 'Reports',
                          value: '12',
                          icon: Icons.bar_chart,
                          color: Colors.purple,
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    GridView.count(
  crossAxisCount: isMobile ? 2 : 4,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisSpacing: 20,
  mainAxisSpacing: 20,
  childAspectRatio: 1.2,

  children: [

    actionCard(
      context,
      'Add Customer',
      Icons.person_add,
      Colors.blue,
      AddCustomerStep1(
  formData: CustomerFormData(),
),
    ),

    actionCard(
  context,
  'Add Employee',
  Icons.badge,
  Colors.green,
  const EmployeesScreen(),
),

    actionCard(
  context,
  'Create Plan',
  Icons.description,
  Colors.orange,
  const ChitPlansScreen(),
),

   actionCard(
  context,
  'View Reports',
  Icons.bar_chart,
  Colors.purple,
  const ReportsScreen(),
),
  ],
),
                    const SizedBox(height: 40),

                    isMobile

                        ? Column(
                            children: [

                              InfoContainer(
                                title: 'Recent Customers',

                                child: Column(
  children: recentCustomers.map<Widget>((customer) {
    return customerTile(
      customer['full_name'],
      customer['customer_id'],
      '',
    );
  }).toList(),
),
                              ),

                              const SizedBox(height: 20),

                              InfoContainer(
                                title: 'Active Subscriptions',

                                child: Column(
  children: recentSubscriptions.map<Widget>((subscription) {

    return subscriptionTile(
      subscription['chit_plan_name'],
      '₹${subscription['monthly_payment']}',
    );

  }).toList(),
),
                              ),
                            ],
                          )

                        : Row(

                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              Expanded(

                                child: InfoContainer(

                                  title: 'Recent Customers',

                                  child: Column(
  children: recentCustomers.map<Widget>((customer) {
    return customerTile(
      customer['full_name'],
      customer['customer_id'],
      '',
    );
  }).toList(),
),
                                ),
                              ),

                              const SizedBox(width: 20),

                              Expanded(

                                child: InfoContainer(

                                  title:
                                      'Active Subscriptions',

                                 child: Column(
  children: recentSubscriptions.map<Widget>((subscription) {

    return subscriptionTile(
      subscription['chit_plan_name'],
      '₹${subscription['monthly_payment']}',
    );

  }).toList(),
),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\edit_customer_screen.dart
```dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class EditCustomerScreen extends StatefulWidget {

  final Map customer;

  const EditCustomerScreen({
    super.key,
    required this.customer,
  });

  @override
  State<EditCustomerScreen> createState() =>
      _EditCustomerScreenState();
}

class _EditCustomerScreenState
    extends State<EditCustomerScreen> {

  late TextEditingController nameController;

  late TextEditingController mobileController;

  late TextEditingController emailController;

  late TextEditingController alternateController;

  late TextEditingController houseController;

  late TextEditingController landmarkController;

  late TextEditingController villageController;

  late TextEditingController talukController;

  late TextEditingController districtController;

  late TextEditingController stateController;

  late TextEditingController pincodeController;

  late TextEditingController companyController;

late TextEditingController officeAddressController;

late TextEditingController officePhoneController;

late TextEditingController officeLandmarkController;
late TextEditingController currentHouseController;
late TextEditingController currentBuildingController;
late TextEditingController currentLandmarkController;
late TextEditingController currentVillageController;
late TextEditingController currentTalukController;
late TextEditingController currentDistrictController;
late TextEditingController currentStateController;
late TextEditingController currentPincodeController;
  
  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.customer['full_name'] ?? '',
    );

    mobileController = TextEditingController(
      text: widget.customer['mobile_number'] ?? '',
    );

    emailController = TextEditingController(
      text: widget.customer['email'] ?? '',
    );

    alternateController = TextEditingController(
  text: widget.customer['alternate_number'] ?? '',
);

houseController = TextEditingController(
  text: widget.customer['home_address']?['house_name'] ?? '',
);

landmarkController = TextEditingController(
  text: widget.customer['home_address']?['landmark'] ?? '',
);

villageController = TextEditingController(
  text: widget.customer['home_address']?['village'] ?? '',
);

talukController = TextEditingController(
  text: widget.customer['home_address']?['taluk'] ?? '',
);

districtController = TextEditingController(
  text: widget.customer['home_address']?['district'] ?? '',
);

stateController = TextEditingController(
  text: widget.customer['home_address']?['state'] ?? '',
);

pincodeController = TextEditingController(
  text: widget.customer['home_address']?['pincode'] ?? '',
);
companyController =
    TextEditingController(
  text: widget.customer[
      'work_address']?['building_name'] ?? '',
);

officeAddressController =
    TextEditingController(
  text: widget.customer[
      'work_address']?['house_name'] ?? '',
);

officePhoneController =
    TextEditingController(
  text: widget.customer[
      'work_address']?['pincode'] ?? '',
);

officeLandmarkController =
    TextEditingController(
  text: widget.customer[
      'work_address']?['landmark'] ?? '',
);
currentHouseController = TextEditingController(
  text: widget.customer['current_address']?['house_name'] ?? '',
);

currentBuildingController = TextEditingController(
  text: widget.customer['current_address']?['building_name'] ?? '',
);

currentLandmarkController = TextEditingController(
  text: widget.customer['current_address']?['landmark'] ?? '',
);

currentVillageController = TextEditingController(
  text: widget.customer['current_address']?['village'] ?? '',
);

currentTalukController = TextEditingController(
  text: widget.customer['current_address']?['taluk'] ?? '',
);

currentDistrictController = TextEditingController(
  text: widget.customer['current_address']?['district'] ?? '',
);

currentStateController = TextEditingController(
  text: widget.customer['current_address']?['state'] ?? '',
);

currentPincodeController = TextEditingController(
  text: widget.customer['current_address']?['pincode'] ?? '',
);
  }
  Future<void> updateCustomer() async {

  bool success =
      await AuthService.updateCustomer(

    customerId: widget.customer['id'],

    fullName: nameController.text,

    mobileNumber: mobileController.text,

    alternateNumber:
        alternateController.text,

    email: emailController.text,

    houseName:
        houseController.text,

    landmark:
        landmarkController.text,

    village:
        villageController.text,

    taluk:
        talukController.text,

    district:
        districtController.text,

    state:
        stateController.text,

    pincode:
        pincodeController.text,
    companyName: companyController.text,

officeAddress: officeAddressController.text,

currentHouseName: currentHouseController.text,

currentBuildingName: currentBuildingController.text,

currentLandmark: currentLandmarkController.text,

currentVillage: currentVillageController.text,

currentTaluk: currentTalukController.text,

currentDistrict: currentDistrictController.text,

currentState: currentStateController.text,

currentPincode: currentPincodeController.text,

officeLandmark: officeLandmarkController.text,

workVillage: "",

workTaluk: "",

workDistrict: "",

workState: "",

workPincode: "",
  );

  if (success) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content: Text(
          'Customer Updated',
        ),
      ),
    );

    Navigator.pop(context,true);
  }

  else {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content: Text(
          'Update Failed',
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Edit Customer',
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
        child: Column(

          children: [
TextField(
  controller: nameController,
  decoration: const InputDecoration(
    labelText: 'Customer Name',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: mobileController,
  decoration: const InputDecoration(
    labelText: 'Mobile Number',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: alternateController,
  decoration: const InputDecoration(
    labelText: 'Alternate Number',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: emailController,
  decoration: const InputDecoration(
    labelText: 'Email',
  ),
),

const SizedBox(height: 25),

const Text(
  'Home Address',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

TextField(
  controller: houseController,
  decoration: const InputDecoration(
    labelText: 'House Name',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: landmarkController,
  decoration: const InputDecoration(
    labelText: 'Landmark',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: villageController,
  decoration: const InputDecoration(
    labelText: 'Village',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: talukController,
  decoration: const InputDecoration(
    labelText: 'Taluk',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: districtController,
  decoration: const InputDecoration(
    labelText: 'District',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: stateController,
  decoration: const InputDecoration(
    labelText: 'State',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: pincodeController,
  decoration: const InputDecoration(
    labelText: 'Pincode',
  ),
),

const SizedBox(height: 25),



const Text(
  'Current Address',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

TextField(
  controller: currentHouseController,
  decoration: const InputDecoration(
    labelText: 'House Name',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: currentBuildingController,
  decoration: const InputDecoration(
    labelText: 'Building Name',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: currentLandmarkController,
  decoration: const InputDecoration(
    labelText: 'Landmark',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: currentVillageController,
  decoration: const InputDecoration(
    labelText: 'Village',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: currentTalukController,
  decoration: const InputDecoration(
    labelText: 'Taluk',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: currentDistrictController,
  decoration: const InputDecoration(
    labelText: 'District',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: currentStateController,
  decoration: const InputDecoration(
    labelText: 'State',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: currentPincodeController,
  decoration: const InputDecoration(
    labelText: 'Pincode',
  ),
),
const SizedBox(height: 25),

const Text(
  'Work Address',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

TextField(
  controller: companyController,
  decoration: const InputDecoration(
    labelText: 'Company Name',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: officeAddressController,
  decoration: const InputDecoration(
    labelText: 'Office Address',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: officePhoneController,
  decoration: const InputDecoration(
    labelText: 'Office Phone',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: officeLandmarkController,
  decoration: const InputDecoration(
    labelText: 'Office Landmark',
  ),
),

const SizedBox(height: 25),


ElevatedButton(
  onPressed: updateCustomer,
  child: const Text(
    'Update Customer',
  ),
),
          ],
        ),
      ),
    ));
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\employees_screen.dart
```dart
import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/employee_dialog.dart';
import '../services/auth_service.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() =>
      _EmployeesScreenState();
}

class _EmployeesScreenState
    extends State<EmployeesScreen> {

  List<dynamic> employees = [];
  List<dynamic> filteredEmployees = [];
  String searchText = '';
  String selectedStatus = 'All Status';
  String selectedRole = 'All Roles';
  @override
void initState() {
  super.initState();
  loadEmployees();
}

Future<void> loadEmployees() async {
  print("Loading employees...");
  final data = await AuthService.getEmployees();
  print("Employees loaded:");
  print(data);
  setState(() {

    employees = data;
    applyFilters();
});  
}
void applyFilters() {
  filteredEmployees = employees.where((e) {
    final name =
        (e['full_name_display'] ?? '')
            .toString()
            .toLowerCase();

    final username =
        (e['username_display'] ?? '')
            .toString()
            .toLowerCase();

    final role =
        (e['role'] ?? '')
            .toString()
            .toLowerCase();

    final status =
        e['is_active'] == true
            ? 'active'
            : 'inactive';

    final matchesSearch =
        name.contains(searchText.toLowerCase()) ||
        username.contains(searchText.toLowerCase());

    final matchesRole =
        selectedRole == 'All Roles' ||
        role ==
            selectedRole.toLowerCase().replaceAll(
                  ' ',
                  '_',
                );

    final matchesStatus =
        selectedStatus == 'All Status' ||
        status ==
            selectedStatus.toLowerCase();

    return matchesSearch &&
        matchesRole &&
        matchesStatus;
  }).toList();
}
  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    bool mobile = width < 900;

    return Scaffold(

      backgroundColor: const Color(0xFF020617),

      body: Row(

        children: [

          if (!mobile)
            const Sidebar(),

          Expanded(

            child: SafeArea(

              child: SingleChildScrollView(

                padding: const EdgeInsets.all(24),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// TOP BAR
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            const Text(
                              'Employees',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Manage team members',

                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        ElevatedButton.icon(

                          onPressed: () async {

  print("OPENING DIALOG");

  final result = await showDialog(
    context: context,
    builder: (_) => const EmployeeDialog(),
  );

  print("DIALOG RESULT: $result");

  if (result == true) {

    print("CALLING LOAD EMPLOYEES");

    await loadEmployees();
  }
},
                          style:
                              ElevatedButton.styleFrom(

                            backgroundColor:
                                Colors.blue,

                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      18),
                            ),
                          ),

                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),

                          label: const Text(
                            'Add Employee',

                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// MAIN CONTAINER
                    Container(

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius:
                            BorderRadius.circular(24),
                      ),

                      child: Column(

                        children: [

                          /// SEARCH + FILTERS
                          mobile
                              ? Column(
                                  children: [

                                    searchBox(),

                                    const SizedBox(
                                        height: 15),

                                    Row(
                                      children: [

                                        Expanded(
                                          child:
                                              dropdownBox(
                                            'All Roles',true
                                          ),
                                        ),

                                        const SizedBox(
                                            width: 12),

                                        Expanded(
                                          child:
                                              dropdownBox(
                                            'All Status',false
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )

                              : Row(
                                  children: [

                                    Expanded(
                                      child: searchBox(),
                                    ),

                                    const SizedBox(
                                        width: 16),

                                    SizedBox(
                                      width: 170,
                                      child:
                                          dropdownBox(
                                        'All Roles', true
                                      ),
                                    ),

                                    const SizedBox(
                                        width: 16),

                                    SizedBox(
                                      width: 170,
                                      child:
                                          dropdownBox(
                                        'All Status', false
                                      ),
                                    ),
                                  ],
                                ),

                          const SizedBox(height: 25),

                          /// EMPLOYEE LIST
                          mobile
                              ? Column(
                                  children:
                                      filteredEmployees.map((e) {

                                    return mobileCard(
                                        e);
                                  }).toList(),
                                )

                              : SingleChildScrollView(
                                  scrollDirection:
                                      Axis.horizontal,

                                  child: DataTable(

                                    columnSpacing: 45,

                                    headingTextStyle:
                                        const TextStyle(
                                      color:
                                          Colors.white70,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),

                                    dataTextStyle:
                                        const TextStyle(
                                      color: Colors.white,
                                    ),

                                    columns: const [

                                      DataColumn(
                                        label: Text(
                                            'EMPLOYEE'),
                                      ),

                                      DataColumn(
                                        label: Text(
                                            'USERNAME'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('CONTACT'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('ROLE'),
                                      ),

                                      DataColumn(
                                        label: Text(
                                            'CUSTOMERS'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('STATUS'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('ACTIONS'),
                                      ),
                                    ],

                                    rows:
                                        filteredEmployees.map((e) {

                                      return DataRow(
                                        cells: [

                                          DataCell(
                                            Row(
                                              children: [

                                                CircleAvatar(
                                                  backgroundColor:
                                                      Colors.blue,

              child: Text(
  ((e['full_name_display']?.toString().isNotEmpty ?? false)
          ? e['full_name_display']
          : e['username_display'])[0]
      .toUpperCase(),
),
                                                ),

                                                const SizedBox(
                                                    width:
                                                        12),

                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,

                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,

                                                  children: [
Text(
  (e['full_name_display']?.toString().isNotEmpty ?? false)
      ? e['full_name_display']
      : e['username_display'],
),

                                                    Text(
                                                       e['employee_id'],

                                                      style:
                                                          const TextStyle(
                                                        color:
                                                            Colors.white54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                               e['username_display'],
                                            ),
                                          ),

                                          DataCell(
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,

                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,

                                              children: [

                                                Text(
                                                   e['email_display'] ?? '',
                                                ),

                                                Text(
                                                  e['phone_number'] ?? '',
                                                ),
                                              ],
                                            ),
                                          ),

                                          DataCell(
                                            chipWidget(
                                              e['role'],
                                              Colors.blue,
                                            ),
                                          ),

                                          DataCell(
  Text(
    e['customer_count'].toString(),
  ),
),

                                          DataCell(
                                            chipWidget(
  e['is_active'] == true
      ? 'Active'
      : 'Inactive',

  e['is_active'] == true
      ? Colors.green
      : Colors.orange,
),
                                          ),

                                          DataCell(
                                            Row(
                                              children: [

                                                IconButton(
  onPressed: () async {

    final result =
        await showDialog(

      context: context,

      builder: (_) =>
          EmployeeDialog(
        employee: e,
      ),
    );

    if (result == true) {
      await loadEmployees();
    }
  },

                                                  icon:
                                                      const Icon(
                                                    Icons.edit,
                                                    color: Colors
                                                        .white70,
                                                  ),
                                                ),

                                                IconButton(

  onPressed: () async {

    final success =
        await AuthService.toggleEmployeeStatus(
      e['id'],
    );

    if (success) {

      await loadEmployees();
    }
  },

  icon: const Icon(
    Icons.power_settings_new,
    color: Colors.white70,
  ),
),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {

    return TextField(
      onChanged: (value) {
  setState(() {
    searchText = value;
    applyFilters();
  });
},

      style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(

        hintText: 'Search employees...',

        hintStyle: const TextStyle(
          color: Colors.white54,
        ),

        prefixIcon: const Icon(
          Icons.search,
          color: Colors.white54,
        ),

        filled: true,
        fillColor: const Color(0xFF0F172A),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget dropdownBox(
  String hint,
  bool isRole,
) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
      ),

      child: DropdownButtonHideUnderline(

        child: DropdownButton<String>(

          dropdownColor:
              const Color(0xFF0F172A),

          value: isRole
    ? selectedRole
    : selectedStatus,

          iconEnabledColor: Colors.white,

          style: const TextStyle(
            color: Colors.white,
          ),

 items: isRole
    ? const [
        DropdownMenuItem(
          value: 'All Roles',
          child: Text('All Roles'),
        ),
        DropdownMenuItem(
          value: 'Admin',
          child: Text('Admin'),
        ),
        DropdownMenuItem(
          value: 'Field Agent',
          child: Text('Field Agent'),
        ),
      ]
    : const [
        DropdownMenuItem(
          value: 'All Status',
          child: Text('All Status'),
        ),
        DropdownMenuItem(
          value: 'Active',
          child: Text('Active'),
        ),
        DropdownMenuItem(
          value: 'Inactive',
          child: Text('Inactive'),
        ),
      ],
   onChanged: (value) {
  setState(() {
    if (isRole) {
      selectedRole = value!;
    } else {
      selectedStatus = value!;
    }
    applyFilters();
  });
},
        ),
      ),
    );
  }

  Widget chipWidget(
    String text,
    Color color,
  ) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        text,

        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget mobileCard(
    Map<String, dynamic> e,
  ) {

    return Container(

      margin: const EdgeInsets.only(bottom: 20),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              CircleAvatar(
                backgroundColor: Colors.blue,

      child: Text(
  ((e['full_name_display']?.toString().isNotEmpty ?? false)
          ? e['full_name_display']
          : e['username_display'])[0]
      .toUpperCase(),
),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
  (e['full_name_display']?.toString().isNotEmpty ?? false)
      ? e['full_name_display']
      : e['username_display'],

  style: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
                    Text(
                      e['employee_id'],

                      style: const TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          infoText(
  'Username',
  e['username_display'] ?? '',
),

infoText(
  'Email',
  e['email_display'] ?? '',
),

infoText(
  'Phone',
  e['phone_number'] ?? '',
),

infoText(
  'Customers',
  e['customer_count'].toString(),
),

          const SizedBox(height: 12),

          Row(
            children: [

              chipWidget(
                e['role'],
                Colors.blue,
              ),

              const SizedBox(width: 10),

              chipWidget(
  e['is_active'] == true
      ? 'Active'
      : 'Inactive',

  e['is_active'] == true
      ? Colors.green
      : Colors.orange,
),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoText(
    String title,
    String value,
  ) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        children: [

          Text(
            '$title : ',

            style: const TextStyle(
              color: Colors.white54,
            ),
          ),

          Expanded(
            child: Text(
              value,

              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\login_screen.dart
```dart
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'agent_dashboard_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final TextEditingController
      usernameController =
      TextEditingController();

  final TextEditingController
      passwordController =
      TextEditingController();

  bool isLoading = false;

  Future<void> login() async {

    setState(() {
      isLoading = true;
    });

    final result = await AuthService.login(

      username:
          usernameController.text.trim(),

      password:
          passwordController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (result['success']) {

      final role = result['role'];

      // ADMIN LOGIN
      if (role == 'admin') {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(
            builder: (_) =>
                const DashboardScreen(),
          ),
        );
      }

      // AGENT LOGIN
      else if (role == 'field_agent') {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(
            builder: (_) =>
                const AgentDashboardScreen(),
          ),
        );
      }

      // UNKNOWN ROLE
      else {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content: Text(
              'Unknown role: $role',
            ),
          ),
        );
      }
    }

    // LOGIN FAILED
    else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            result['message'],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF020617),

      body: Center(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(24),

          child: ConstrainedBox(

            constraints:
                const BoxConstraints(
              maxWidth: 450,
            ),

            child: Column(

              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                const Text(
                  'Chitty Finance',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Role Based Login System',

                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 45),

                /// USERNAME
                TextField(

                  controller:
                      usernameController,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(

                    hintText: 'Username',

                    hintStyle:
                        const TextStyle(
                      color: Colors.white70,
                    ),

                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.white70,
                    ),

                    filled: true,

                    fillColor:
                        Colors.white10,

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                              14),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// PASSWORD
                TextField(

                  controller:
                      passwordController,

                  obscureText: true,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(

                    hintText: 'Password',

                    hintStyle:
                        const TextStyle(
                      color: Colors.white70,
                    ),

                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.white70,
                    ),

                    filled: true,

                    fillColor:
                        Colors.white10,

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                              14),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                /// LOGIN BUTTON
                SizedBox(

                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(

                    onPressed:
                        isLoading ? null : login,

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue,
                    ),

                    child: isLoading

                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )

                        : const Text(

                            'Login',

                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\reports_screen.dart
```dart
import 'package:flutter/material.dart';

import '../widgets/sidebar.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    bool mobile = width < 900;

    return Scaffold(

      backgroundColor: const Color(0xFF020617),

      body: Row(

        children: [

          if (!mobile)
            const Sidebar(),

          Expanded(

            child: SafeArea(

              child: SingleChildScrollView(

                padding: const EdgeInsets.all(24),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// HEADER
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            const Text(
                              'Reports & Analytics',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'View detailed business insights',

                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        ElevatedButton.icon(

                          onPressed: () {},

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF334155),

                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      18),
                            ),
                          ),

                          icon: const Icon(
                            Icons.download,
                            color: Colors.white,
                          ),

                          label: const Text(
                            'Export Report',

                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// FILTERS
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,

                      children: [

                        filterChip(
                          'This Month',
                          true,
                        ),

                        filterChip(
                          'Last Month',
                          false,
                        ),

                        filterChip(
                          'Last 3 Months',
                          false,
                        ),

                        filterChip(
                          'This Year',
                          false,
                        ),

                        filterChip(
                          'Custom Range',
                          false,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// ANALYTICS CARDS
                    GridView.count(

                      shrinkWrap: true,

                      physics:
                          const NeverScrollableScrollPhysics(),

                      crossAxisCount:
                          mobile ? 1 : 4,

                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,

                      childAspectRatio:
                          mobile ? 2.5 : 1.6,

                      children: [

                        analyticsCard(
                          'Total Collections',
                          '₹5000',
                          '+18.5%',
                          Icons.currency_rupee,
                          Colors.blue,
                        ),

                        analyticsCard(
                          'New Customers',
                          '1',
                          '+12%',
                          Icons.people,
                          Colors.green,
                        ),

                        analyticsCard(
                          'Active Chitties',
                          '1',
                          '+5%',
                          Icons.trending_up,
                          Colors.lightBlueAccent,
                        ),

                        analyticsCard(
                          'Pending Payments',
                          '0',
                          '-2%',
                          Icons.calendar_today,
                          Colors.orange,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// CHART SECTION
                    mobile
                        ? Column(
                            children: [

                              chartBox(
                                title:
                                    'Monthly Collections',

                                subtitle:
                                    'Last 6 months trend',
                              ),

                              const SizedBox(height: 20),

                              distributionBox(),
                            ],
                          )

                        : Row(
                            children: [

                              Expanded(
                                child: chartBox(
                                  title:
                                      'Monthly Collections',

                                  subtitle:
                                      'Last 6 months trend',
                                ),
                              ),

                              const SizedBox(width: 20),

                              Expanded(
                                child:
                                    distributionBox(),
                              ),
                            ],
                          ),

                    const SizedBox(height: 30),

                    /// PAYMENT OVERVIEW
                    Container(

                      padding:
                          const EdgeInsets.all(24),

                      decoration: BoxDecoration(
                        color: const Color(
                            0xFF1E293B),

                        borderRadius:
                            BorderRadius.circular(
                                24),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          const Text(
                            'Payment Status Overview',

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 25),

                          SingleChildScrollView(
                            scrollDirection:
                                Axis.horizontal,

                            child: DataTable(

                              headingTextStyle:
                                  const TextStyle(
                                color:
                                    Colors.white70,
                                fontWeight:
                                    FontWeight.bold,
                              ),

                              dataTextStyle:
                                  const TextStyle(
                                color: Colors.white,
                              ),

                              columns: const [

                                DataColumn(
                                  label: Text(
                                      'PLAN NAME'),
                                ),

                                DataColumn(
                                  label:
                                      Text('PAID'),
                                ),

                                DataColumn(
                                  label:
                                      Text('PENDING'),
                                ),

                                DataColumn(
                                  label:
                                      Text('OVERDUE'),
                                ),

                                DataColumn(
                                  label: Text(
                                      'COLLECTION RATE'),
                                ),
                              ],

                              rows: [

                                DataRow(
                                  cells: [

                                    const DataCell(
                                      Text('Overall'),
                                    ),

                                    DataCell(
                                      statusBox(
                                        '1',
                                        Colors.green,
                                      ),
                                    ),

                                    DataCell(
                                      statusBox(
                                        '0',
                                        Colors.orange,
                                      ),
                                    ),

                                    DataCell(
                                      statusBox(
                                        '0',
                                        Colors.red,
                                      ),
                                    ),

                                    const DataCell(
                                      Text(
                                        'Live Data',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterChip(
    String title,
    bool active,
  ) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF1E3A8A)
            : const Color(0xFF1E293B),

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Text(
        title,

        style: TextStyle(
          color: active
              ? Colors.blue.shade200
              : Colors.white,
        ),
      ),
    );
  }

  Widget analyticsCard(
    String title,
    String value,
    String growth,
    IconData icon,
    Color color,
  ) {

    return Container(

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [

              Expanded(
                child: Text(
                  title,

                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),

              Container(

                padding:
                    const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: color,
                  borderRadius:
                      BorderRadius.circular(
                          16),
                ),

                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            value,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '$growth vs last month',

            style: TextStyle(
              color: growth.contains('-')
                  ? Colors.red
                  : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget chartBox({
    required String title,
    required String subtitle,
  }) {

    return Container(

      height: 350,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Container(

                padding:
                    const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color:
                      const Color(0xFF1E3A8A),

                  borderRadius:
                      BorderRadius.circular(
                          14),
                ),

                child: const Icon(
                  Icons.bar_chart,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 14),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    title,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  Text(
                    subtitle,

                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,

            children: const [

              Text('Jan',
                  style: TextStyle(
                      color: Colors.white38)),

              Text('Feb',
                  style: TextStyle(
                      color: Colors.white38)),

              Text('Mar',
                  style: TextStyle(
                      color: Colors.white38)),

              Text('Apr',
                  style: TextStyle(
                      color: Colors.white38)),

              Text('May',
                  style: TextStyle(
                      color: Colors.white38)),

              Text('Jun',
                  style: TextStyle(
                      color: Colors.white38)),
            ],
          ),
        ],
      ),
    );
  }

  Widget distributionBox() {

    return Container(

      height: 350,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Container(

                padding:
                    const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: Colors.green
                      .withOpacity(0.2),

                  borderRadius:
                      BorderRadius.circular(
                          14),
                ),

                child: const Icon(
                  Icons.pie_chart,
                  color: Colors.green,
                ),
              ),

              const SizedBox(width: 14),

              const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    'Plan Distribution',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  Text(
                    'Active subscriptions by plan',

                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 35),

          const Text(
            'gold savings',

            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 12),

          ClipRRect(

            borderRadius:
                BorderRadius.circular(12),

            child: LinearProgressIndicator(
              value: 0.75,
              minHeight: 12,
              backgroundColor:
                  Colors.white10,
              color: Colors.blue,
            ),
          ),

          const SizedBox(height: 10),

          const Align(
            alignment: Alignment.centerRight,

            child: Text(
              '1 customers',

              style: TextStyle(
                color: Colors.white54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statusBox(
    String value,
    Color color,
  ) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(0.2),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Text(
        value,

        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\settings_screen.dart
```dart
import 'package:flutter/material.dart';

import '../widgets/sidebar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  bool darkMode = true;

  bool emailNotifications = true;
  bool smsNotifications = false;
  bool pushNotifications = true;

  bool overdueAlerts = true;
  bool customerAlerts = true;

  final TextEditingController fullName =
      TextEditingController(text: 'Admin');

  final TextEditingController email =
      TextEditingController();

  final TextEditingController phone =
      TextEditingController();

  final TextEditingController username =
      TextEditingController(text: 'admin');

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    bool mobile = width < 900;

    return Scaffold(

      backgroundColor: const Color(0xFF020617),

      body: Row(

        children: [

          if (!mobile)
            const Sidebar(),

          Expanded(

            child: SafeArea(

              child: SingleChildScrollView(

                padding: const EdgeInsets.all(24),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// HEADER
                    const Text(
                      'Settings',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Manage your account preferences',

                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// PROFILE SETTINGS
                    settingsContainer(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          sectionTitle(
                            Icons.lock_outline,
                            Colors.blue,
                            'Profile Settings',
                            'Update your personal information',
                          ),

                          const SizedBox(height: 30),

                          mobile
                              ? Column(
                                  children: [

                                    buildField(
                                      'Full Name',
                                      fullName,
                                    ),

                                    const SizedBox(height: 18),

                                    buildField(
                                      'Email Address',
                                      email,
                                    ),

                                    const SizedBox(height: 18),

                                    buildField(
                                      'Phone Number',
                                      phone,
                                    ),

                                    const SizedBox(height: 18),

                                    buildField(
                                      'Username',
                                      username,
                                    ),
                                  ],
                                )

                              : Column(
                                  children: [

                                    Row(
                                      children: [

                                        Expanded(
                                          child: buildField(
                                            'Full Name',
                                            fullName,
                                          ),
                                        ),

                                        const SizedBox(width: 20),

                                        Expanded(
                                          child: buildField(
                                            'Email Address',
                                            email,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 20),

                                    Row(
                                      children: [

                                        Expanded(
                                          child: buildField(
                                            'Phone Number',
                                            phone,
                                          ),
                                        ),

                                        const SizedBox(width: 20),

                                        Expanded(
                                          child: buildField(
                                            'Username',
                                            username,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                          const SizedBox(height: 28),

                          const Divider(
                            color: Colors.white10,
                          ),

                          const SizedBox(height: 24),

                          ElevatedButton.icon(

                            onPressed: () {},

                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(
                                      0xFF60A5FA),

                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 18,
                              ),

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        16),
                              ),
                            ),

                            icon: const Icon(
                              Icons.save_outlined,
                              color: Colors.white,
                            ),

                            label: const Text(
                              'Save Changes',

                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    /// APPEARANCE
                    settingsContainer(
                      child: Column(
                        children: [

                          sectionTitle(
                            Icons.dark_mode,
                            Colors.green,
                            'Appearance',
                            'Customize the interface theme',
                          ),

                          const SizedBox(height: 28),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,

                            children: [

                              Row(
                                children: [

                                  iconBox(
                                    Icons.nightlight_round,
                                  ),

                                  const SizedBox(width: 16),

                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [

                                      Text(
                                        'Dark Mode',

                                        style: TextStyle(
                                          color:
                                              Colors.white,
                                          fontSize: 20,
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                        ),
                                      ),

                                      SizedBox(height: 4),

                                      Text(
                                        'Currently enabled',

                                        style: TextStyle(
                                          color: Colors
                                              .white54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              Switch(

                                value: darkMode,

                                activeColor:
                                    Colors.blue,

                                onChanged: (value) {

                                  setState(() {
                                    darkMode = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    /// NOTIFICATIONS
                    settingsContainer(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          sectionTitle(
                            Icons.notifications_none,
                            Colors.blue,
                            'Notifications',
                            'Configure how you receive alerts',
                          ),

                          const SizedBox(height: 30),

                          notificationRow(
                            icon: Icons.email_outlined,
                            title:
                                'Email Notifications',
                            subtitle:
                                'Receive updates via email',
                            value: emailNotifications,
                            onChanged: (v) {
                              setState(() {
                                emailNotifications =
                                    v!;
                              });
                            },
                          ),

                          const SizedBox(height: 18),

                          notificationRow(
                            icon: Icons.phone_android,
                            title: 'SMS Alerts',
                            subtitle:
                                'Get important alerts via SMS',
                            value: smsNotifications,
                            onChanged: (v) {
                              setState(() {
                                smsNotifications =
                                    v!;
                              });
                            },
                          ),

                          const SizedBox(height: 18),

                          notificationRow(
                            icon:
                                Icons.notifications_active,
                            title:
                                'Push Notifications',
                            subtitle:
                                'Browser push notifications',
                            value: pushNotifications,
                            onChanged: (v) {
                              setState(() {
                                pushNotifications =
                                    v!;
                              });
                            },
                          ),

                          const SizedBox(height: 30),

                          const Divider(
                            color: Colors.white10,
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            'Alert Types',

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 22),

                          CheckboxListTile(

                            value: overdueAlerts,

                            activeColor:
                                Colors.purple,

                            title: const Text(
                              'Overdue payment reminders',

                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),

                            onChanged: (v) {
                              setState(() {
                                overdueAlerts = v!;
                              });
                            },
                          ),

                          CheckboxListTile(

                            value: customerAlerts,

                            activeColor:
                                Colors.purple,

                            title: const Text(
                              'New customer onboarded',

                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),

                            onChanged: (v) {
                              setState(() {
                                customerAlerts = v!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    /// DANGER ZONE
                    Container(

                      width: double.infinity,

                      padding: const EdgeInsets.all(26),

                      decoration: BoxDecoration(
                        color: const Color(
                            0xFF1E293B),

                        borderRadius:
                            BorderRadius.circular(24),

                        border: Border.all(
                          color: Colors.red
                              .withOpacity(0.5),
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          const Text(
                            'Danger Zone',

                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 28,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 14),

                          const Text(
                            'These actions are irreversible. Please proceed with caution.',

                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 28),

                          Wrap(
                            spacing: 18,
                            runSpacing: 18,

                            children: [

                              ElevatedButton(

                                onPressed: () {},

                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.redAccent,

                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 26,
                                    vertical: 18,
                                  ),

                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            16),
                                  ),
                                ),

                                child: const Text(
                                  'Delete Account',

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),

                              ElevatedButton(

                                onPressed: () {},

                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(
                                          0xFF475569),

                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 26,
                                    vertical: 18,
                                  ),

                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            16),
                                  ),
                                ),

                                child: const Text(
                                  'Export Data',

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget settingsContainer({
    required Widget child,
  }) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: child,
    );
  }

  Widget sectionTitle(
    IconData icon,
    Color color,
    String title,
    String subtitle,
  ) {

    return Row(
      children: [

        Container(

          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(
            color: color.withOpacity(0.15),

            borderRadius:
                BorderRadius.circular(14),
          ),

          child: Icon(
            icon,
            color: color,
          ),
        ),

        const SizedBox(width: 16),

        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              title,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,

              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller,
  ) {

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          label,

          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 12),

        TextField(

          controller: controller,

          style:
              const TextStyle(color: Colors.white),

          decoration: InputDecoration(

            filled: true,

            fillColor:
                const Color(0xFF1E293B),

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(16),

              borderSide: BorderSide(
                color:
                    Colors.white.withOpacity(0.1),
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(16),

              borderSide: BorderSide(
                color:
                    Colors.white.withOpacity(0.1),
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(16),

              borderSide:
                  const BorderSide(
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget iconBox(IconData icon) {

    return Container(

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: const Color(0xFF334155),

        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Icon(
        icon,
        color: Colors.white70,
      ),
    );
  }

  Widget notificationRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        Expanded(
          child: Row(
            children: [

              iconBox(icon),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      title,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,

                      style: const TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Checkbox(
          value: value,
          activeColor: Colors.purple,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\subscriptions_screen.dart
```dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/sidebar.dart';
import '../widgets/subscription_dialog.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() =>
      _SubscriptionsScreenState();
}

class _SubscriptionsScreenState
    extends State<SubscriptionsScreen> {

  List<dynamic> subscriptions = [];
  bool isLoading = true;
  @override
void initState() {
  super.initState();
  loadSubscriptions();
}

Future<void> loadSubscriptions() async {
  final data = await AuthService.getSubscriptions();

  setState(() {
    subscriptions = data;
    isLoading = false;
  });

  print(data);
}
  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    bool mobile = width < 900;

    return Scaffold(

      backgroundColor: const Color(0xFF020617),

      body: Row(

        children: [

          if (!mobile)
            const Sidebar(),

          Expanded(

            child: SafeArea(

              child: SingleChildScrollView(

                padding: const EdgeInsets.all(24),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// HEADER
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            const Text(
                              'Subscriptions',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Manage customer subscriptions',

                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        ElevatedButton.icon(

                          onPressed: () async {

  final result = await showDialog(
    context: context,
    builder: (_) =>
        const SubscriptionDialog(),
  );

  if (result == true) {
    await loadSubscriptions();
  }
},

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blue,

                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      18),
                            ),
                          ),

                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),

                          label: const Text(
                            'Enroll Customer',

                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// MAIN BOX
                    Container(

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius:
                            BorderRadius.circular(24),
                      ),

                      child: Column(
                        children: [

                          /// SEARCH
                          TextField(

                            style: const TextStyle(
                              color: Colors.white,
                            ),

                            decoration: InputDecoration(

                              hintText:
                                  'Search subscriptions...',

                              hintStyle:
                                  const TextStyle(
                                color: Colors.white54,
                              ),

                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white54,
                              ),

                              filled: true,
                              fillColor:
                                  const Color(
                                      0xFF0F172A),

                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(16),

                                borderSide:
                                    BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),
                          if (isLoading)
  const Center(
    child: CircularProgressIndicator(),
  )
else

                          mobile
                              ? Column(
                                  children:
                                      subscriptions
                                          .map((s) {

                                    return mobileCard(
                                        s);
                                  }).toList(),
                                )

                              : SingleChildScrollView(
                                  scrollDirection:
                                      Axis.horizontal,

                                  child: DataTable(

                                    columnSpacing: 45,

                                    headingTextStyle:
                                        const TextStyle(
                                      color:
                                          Colors.white70,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),

                                    dataTextStyle:
                                        const TextStyle(
                                      color: Colors.white,
                                    ),

                                    columns: const [

                                      DataColumn(
                                        label: Text(
                                            'CUSTOMER'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('PLAN'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('AMOUNT'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('STATUS'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('PAYMENT'),
                                      ),

                                      DataColumn(
                                        label:
                                            Text('JOINED'),
                                      ),
                                    ],

                                    rows:
                                        subscriptions
                                            .map((s) {

                                      return DataRow(
                                        cells: [

                                          DataCell(
                                            Text(
                                              s['customer_name'],
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              s['chit_plan_name'],
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              s['chit_plan_code'],

                                              style:
                                                  const TextStyle(
                                                color:
                                                    Colors.green,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                          ),

                                          DataCell(
                                            statusChip(
                                              s['subscription_status'],
                                            ),
                                          ),

                                          DataCell(
                                            paymentChip(
                                              s['payment_status'],
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              s['joined_date'],
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statusChip(String status) {

    Color color = status == 'Active'
        ? Colors.green
        : Colors.orange;

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        status,

        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget paymentChip(String status) {

    Color color = status == 'Paid'
        ? Colors.green
        : Colors.redAccent;

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        status,

        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget mobileCard(
    Map<String, dynamic> s,
  ) {

    return Container(

      margin: const EdgeInsets.only(bottom: 20),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            s['customer'],

            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            s['plan'],

            style: const TextStyle(
              color: Colors.white54,
            ),
          ),

          const SizedBox(height: 20),

          infoText('Amount', s['amount']),
          infoText('Joined', s['date']),

          const SizedBox(height: 15),

          Row(
            children: [

              statusChip(s['status']),

              const SizedBox(width: 10),

              paymentChip(s['payment']),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoText(
    String title,
    String value,
  ) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        children: [

          Text(
            '$title : ',

            style: const TextStyle(
              color: Colors.white54,
            ),
          ),

          Expanded(
            child: Text(
              value,

              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\add_customer\add_customer_step1.dart
```dart
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'add_customer_step2.dart';
import 'customer_form_data.dart';


class AddCustomerStep1 extends StatefulWidget {

  final CustomerFormData formData;

  const AddCustomerStep1({
    super.key,
    required this.formData,
  });

  @override
  State<AddCustomerStep1> createState() => _AddCustomerStep1State();
}

class _AddCustomerStep1State extends State<AddCustomerStep1> {

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final alternateController = TextEditingController();
  final emailController = TextEditingController();
  final houseController = TextEditingController();
  final landmarkController = TextEditingController();
  final villageController = TextEditingController();
  final talukController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  String selectedCustomerType = "Customer";
  final otherCustomerTypeController = TextEditingController();
  GoogleMapController? mapController;

  LatLng customerLocation = const LatLng(
    8.8932,
    76.6141,
);

File? customerPhotoFile;
File? addressProofFile;
File? idProofFile;

@override
void initState() {
  super.initState();
  getCurrentLocation();
}

  Future<void> getCurrentLocation() async {
    try {
      final bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showLocationMessage(
          'Location is off. Tap the map to set the location manually.',
        );
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showLocationMessage(
          'Location permission denied. Tap the map to set the location manually.',
        );
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      final newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        customerLocation = newLocation;
      });
      mapController?.animateCamera(
        CameraUpdate.newLatLng(newLocation),
      );
    } catch (e) {
      _showLocationMessage(
        'Could not get current location. Tap the map to set it manually.',
      );
    }
  }
  void _showLocationMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  Future<void> pickImage(String type) async {
  final picker = ImagePicker();

  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder: (context) => SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(
                context,
                ImageSource.camera,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(
                context,
                ImageSource.gallery,
              );
            },
          ),
        ],
      ),
    ),
  );

  if (source == null) return;

  final pickedFile = await picker.pickImage(
    source: source,
  );

  if (pickedFile == null) return;

  setState(() {
    if (type == 'customer') {
      customerPhotoFile = File(pickedFile.path);
    } else if (type == 'address') {
      addressProofFile = File(pickedFile.path);
    } else if (type == 'id') {
      idProofFile = File(pickedFile.path);
    }
  });
}

  Widget buildField(
    String hint,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: TextField(
        controller: controller,

        style: const TextStyle(
          color: Colors.white,
        ),

        decoration: InputDecoration(
          hintText: hint,

          hintStyle: const TextStyle(
            color: Colors.white54,
          ),

          filled: true,
          fillColor: const Color(0xFF111827),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
    Widget uploadBox(
  String title,
  File? file,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 170,
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white24,
        ),
      ),
      child: file != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                file,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.upload_file,
                  color: Colors.white54,
                  size: 45,
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap to upload',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    final mobile = width < 700;

    return Scaffold(

      backgroundColor: const Color(0xFF020617),

      appBar: AppBar(

        backgroundColor: const Color(0xFF020617),

        title: const Text(
          "Add Customer",
          style: TextStyle(color: Colors.white),
        ),

      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const Text(

                "Personal Information",

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 24,

                  fontWeight: FontWeight.bold,

                ),
              ),

              const SizedBox(height: 25),

              if (mobile)

                Column(

                  children: [
                    DropdownButtonFormField<String>(
  value: selectedCustomerType,
  dropdownColor: const Color(0xFF111827),

  decoration: InputDecoration(
    filled: true,
    fillColor: const Color(0xFF111827),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  ),

  style: const TextStyle(
    color: Colors.white,
  ),

  items: const [

    DropdownMenuItem(
      value: "Customer",
      child: Text("Customer"),
    ),

    DropdownMenuItem(
      value: "Agent",
      child: Text("Agent"),
    ),

    DropdownMenuItem(
      value: "Guarantor",
      child: Text("Guarantor"),
    ),

    DropdownMenuItem(
      value: "Agent & Guarantor",
      child: Text("Agent & Guarantor"),
    ),

    DropdownMenuItem(
      value: "Other",
      child: Text("Other"),
    ),
  ],

  onChanged: (value) {

    setState(() {

      selectedCustomerType = value!;

    });

  },
),


const SizedBox(height: 18),
if (selectedCustomerType == "Other") ...[
  buildField(
    "Specify Customer Type",
    otherCustomerTypeController,
  ),

  const SizedBox(height: 18),
],

                    buildField(
                      "Customer Name",
                      nameController,
                    ),

                    buildField(
                      "Primary Mobile Number",
                      mobileController,
                    ),

                    buildField(
                      "Alternate Mobile Number",
                      alternateController,
                    ),

                    buildField(
                      "Email Address",
                      emailController,
                    ),
                  ],
                )

              else

                Row(

                  children: [

                    Expanded(

                      child: Column(

                        children: [

                          buildField(
                            "Customer Name",
                            nameController,
                          ),

                          buildField(
                            "Primary Mobile Number",
                            mobileController,
                          ),

                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(

                      child: Column(

                        children: [

                          buildField(
                            "Alternate Mobile Number",
                            alternateController,
                          ),

                          buildField(
                            "Email Address",
                            emailController,
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
const Text(
  "Home Address",
  style: TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 20),

if (mobile)

  Column(
    children: [

      buildField(
        "House Name",
        houseController,
      ),

      buildField(
        "Landmark",
        landmarkController,
      ),

      buildField(
        "Village / Area",
        villageController,
      ),

      buildField(
        "Taluk",
        talukController,
      ),

      buildField(
        "District",
        districtController,
      ),

      buildField(
        "State",
        stateController,
      ),

      buildField(
        "PIN Code",
        pincodeController,
      ),
    ],
  )

else

  Row(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [

      Expanded(
        child: Column(
          children: [

            buildField(
              "House Name",
              houseController,
            ),

            buildField(
              "Village / Area",
              villageController,
            ),

            buildField(
              "District",
              districtController,
            ),

            buildField(
              "PIN Code",
              pincodeController,
            ),

          ],
        ),
      ),

      const SizedBox(width: 20),

      Expanded(
        child: Column(
          children: [

            buildField(
              "Landmark",
              landmarkController,
            ),

            buildField(
              "Taluk",
              talukController,
            ),

            buildField(
              "State",
              stateController,
            ),

          ],
        ),
      ),
    ],
  ),
              //const SizedBox(height: 30),
              const SizedBox(height: 20),

SizedBox(
  height: 320,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: GoogleMap(
      initialCameraPosition: CameraPosition(
        target: customerLocation,
        zoom: 14,
      ),
      onMapCreated: (controller) {
        mapController = controller;
      },
      onTap: (LatLng position) {
        setState(() {
          customerLocation = position;
        });
      },
      markers: {
        Marker(
          markerId: const MarkerId('customer'),
          position: customerLocation,
        ),
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
    ),
  ),
),

const SizedBox(height: 20),

Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: const Color(0xFF111827),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Selected Location",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        "Latitude : ${customerLocation.latitude}",
        style: const TextStyle(color: Colors.white70),
      ),
      Text(
        "Longitude : ${customerLocation.longitude}",
        style: const TextStyle(color: Colors.white70),
      ),
    ],
  ),
),

const SizedBox(height: 30),
const Text(
  "Photo Uploads",
  style: TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 20),

GridView.count(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisCount: mobile ? 1 : 2,
  crossAxisSpacing: 20,
  mainAxisSpacing: 20,
  childAspectRatio: 1.5,
  children: [

    uploadBox(
      'Customer Photo',
      customerPhotoFile,
      () => pickImage('customer'),
    ),

    uploadBox(
      'Home Address Proof',
      addressProofFile,
      () => pickImage('address'),
    ),

    uploadBox(
      'ID Proof',
      idProofFile,
      () => pickImage('id'),
    ),

  ],
),

const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,

                height: 55,

                child: ElevatedButton(

                  onPressed: () {

  // Personal Information
  widget.formData.fullName = nameController.text;
  widget.formData.mobileNumber = mobileController.text;
  widget.formData.alternateNumber = alternateController.text;
  widget.formData.email = emailController.text;
  widget.formData.customerType = selectedCustomerType;

widget.formData.otherCustomerType =
    otherCustomerTypeController.text;
  // Home Address
  widget.formData.homeHouseName = houseController.text;
  widget.formData.homeLandmark = landmarkController.text;
  widget.formData.homeVillage = villageController.text;
  widget.formData.homeTaluk = talukController.text;
  widget.formData.homeDistrict = districtController.text;
  widget.formData.homeState = stateController.text;
  widget.formData.homePincode = pincodeController.text;

  widget.formData.homeLatitude = customerLocation.latitude;
  widget.formData.homeLongitude = customerLocation.longitude;

  // Photos
  widget.formData.customerPhoto = customerPhotoFile;
  widget.formData.homeAddressProof = addressProofFile;
  widget.formData.idProof = idProofFile;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AddCustomerStep2(
        formData: widget.formData,
      ),
    ),
  );

},

                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.blue,

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(16),

                    ),

                  ),

                  child: const Text(

                    "Next",

                    style: TextStyle(

                      fontSize: 18,

                    ),

                  ),

                ),

              ),

            ],
          ),
        ),
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\add_customer\add_customer_step2.dart
```dart
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
//import 'add_customer_step2.dart';
import 'customer_form_data.dart';
import 'add_customer_step3.dart';

class AddCustomerStep2 extends StatefulWidget {

  final CustomerFormData formData;

  const AddCustomerStep2({
    super.key,
    required this.formData,
  });

  @override
  State<AddCustomerStep2> createState() => _AddCustomerStep2State();
}

class _AddCustomerStep2State extends State<AddCustomerStep2> {

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final alternateController = TextEditingController();
  final emailController = TextEditingController();
  final houseController = TextEditingController();
  final landmarkController = TextEditingController();
  final villageController = TextEditingController();
  final talukController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  GoogleMapController? mapController;

  LatLng customerLocation = const LatLng(
    8.8932,
    76.6141,
);

File? customerPhotoFile;
File? addressProofFile;
File? idProofFile;

@override
void initState() {
  super.initState();
  getCurrentLocation();
}

  Future<void> getCurrentLocation() async {
    try {
      final bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showLocationMessage(
          'Location is off. Tap the map to set the location manually.',
        );
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showLocationMessage(
          'Location permission denied. Tap the map to set the location manually.',
        );
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      final newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        customerLocation = newLocation;
      });
      mapController?.animateCamera(
        CameraUpdate.newLatLng(newLocation),
      );
    } catch (e) {
      _showLocationMessage(
        'Could not get current location. Tap the map to set it manually.',
      );
    }
  }
  void _showLocationMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  Future<void> pickImage(String type) async {
  final picker = ImagePicker();

  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder: (context) => SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(
                context,
                ImageSource.camera,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(
                context,
                ImageSource.gallery,
              );
            },
          ),
        ],
      ),
    ),
  );

  if (source == null) return;

  final pickedFile = await picker.pickImage(
    source: source,
  );

  if (pickedFile == null) return;

  setState(() {
    if (type == 'customer') {
      customerPhotoFile = File(pickedFile.path);
    } else if (type == 'address') {
      addressProofFile = File(pickedFile.path);
    } else if (type == 'id') {
      idProofFile = File(pickedFile.path);
    }
  });
}

  Widget buildField(
    String hint,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: TextField(
        controller: controller,

        style: const TextStyle(
          color: Colors.white,
        ),

        decoration: InputDecoration(
          hintText: hint,

          hintStyle: const TextStyle(
            color: Colors.white54,
          ),

          filled: true,
          fillColor: const Color(0xFF111827),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
    Widget uploadBox(
  String title,
  File? file,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 170,
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white24,
        ),
      ),
      child: file != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                file,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.upload_file,
                  color: Colors.white54,
                  size: 45,
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap to upload',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    final mobile = width < 700;

    return Scaffold(

      backgroundColor: const Color(0xFF020617),

      appBar: AppBar(

        backgroundColor: const Color(0xFF020617),

        title: const Text(
          "Add Customer",
          style: TextStyle(color: Colors.white),
        ),

      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              
const Text(
  "Current Address",
  style: TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 20),

if (mobile)

  Column(
    children: [

      buildField(
        "House Name",
        houseController,
      ),

      buildField(
        "Landmark",
        landmarkController,
      ),

      buildField(
        "Village / Area",
        villageController,
      ),

      buildField(
        "Taluk",
        talukController,
      ),

      buildField(
        "District",
        districtController,
      ),

      buildField(
        "State",
        stateController,
      ),

      buildField(
        "PIN Code",
        pincodeController,
      ),
    ],
  )

else

  Row(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [

      Expanded(
        child: Column(
          children: [

            buildField(
              "House Name",
              houseController,
            ),

            buildField(
              "Village / Area",
              villageController,
            ),

            buildField(
              "District",
              districtController,
            ),

            buildField(
              "PIN Code",
              pincodeController,
            ),

          ],
        ),
      ),

      const SizedBox(width: 20),

      Expanded(
        child: Column(
          children: [

            buildField(
              "Landmark",
              landmarkController,
            ),

            buildField(
              "Taluk",
              talukController,
            ),

            buildField(
              "State",
              stateController,
            ),

          ],
        ),
      ),
    ],
  ),
              //const SizedBox(height: 30),
              const SizedBox(height: 20),

SizedBox(
  height: 320,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: GoogleMap(
      initialCameraPosition: CameraPosition(
        target: customerLocation,
        zoom: 14,
      ),
      onMapCreated: (controller) {
        mapController = controller;
      },
      onTap: (LatLng position) {
        setState(() {
          customerLocation = position;
        });
      },
      markers: {
        Marker(
          markerId: const MarkerId('customer'),
          position: customerLocation,
        ),
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
    ),
  ),
),

const SizedBox(height: 20),

Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: const Color(0xFF111827),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Selected Location",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        "Latitude : ${customerLocation.latitude}",
        style: const TextStyle(color: Colors.white70),
      ),
      Text(
        "Longitude : ${customerLocation.longitude}",
        style: const TextStyle(color: Colors.white70),
      ),
    ],
  ),
),

const SizedBox(height: 30),
const Text(
  "Photo Uploads",
  style: TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 20),

GridView.count(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisCount: mobile ? 1 : 2,
  crossAxisSpacing: 20,
  mainAxisSpacing: 20,
  childAspectRatio: 1.5,
  children: [

    

    uploadBox(
      'Current Address Proof',
      addressProofFile,
      () => pickImage('address'),
    ),

    

  ],
),

const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,

                height: 55,

                child: ElevatedButton(

                  onPressed: () {

  // Current Address
widget.formData.currentHouseName = houseController.text;
widget.formData.currentBuildingName = '';
widget.formData.currentLandmark = landmarkController.text;
widget.formData.currentVillage = villageController.text;
widget.formData.currentTaluk = talukController.text;
widget.formData.currentDistrict = districtController.text;
widget.formData.currentState = stateController.text;
widget.formData.currentPincode = pincodeController.text;

widget.formData.currentLatitude = customerLocation.latitude;
widget.formData.currentLongitude = customerLocation.longitude;

// Current Address Proof
widget.formData.currentAddressProof = addressProofFile;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AddCustomerStep3(
        formData: widget.formData,
      ),
    ),
  );

},
                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.blue,

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(16),

                    ),

                  ),

                  child: const Text(

                    "Next",

                    style: TextStyle(

                      fontSize: 18,

                    ),

                  ),

                ),

              ),

            ],
          ),
        ),
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\add_customer\add_customer_step3.dart
```dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chitty_mobile/services/auth_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'customer_form_data.dart';

class AddCustomerStep3 extends StatefulWidget {

  final CustomerFormData formData;

  const AddCustomerStep3({
    super.key,
    required this.formData,
  });

  @override
  State<AddCustomerStep3> createState() => _AddCustomerStep3State();
}

class _AddCustomerStep3State extends State<AddCustomerStep3> {

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final alternateController = TextEditingController();
  final emailController = TextEditingController();
  //final houseController = TextEditingController();
  final landmarkController = TextEditingController();
  final villageController = TextEditingController();
  final talukController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final companyController = TextEditingController();
  final officeAddressController = TextEditingController();
  GoogleMapController? mapController;

  LatLng customerLocation = const LatLng(
    8.8932,
    76.6141,
);

File? customerPhotoFile;
File? addressProofFile;
File? idProofFile;

@override
void initState() {
  super.initState();
  getCurrentLocation();
}

  Future<void> getCurrentLocation() async {
    try {
      final bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showLocationMessage(
          'Location is off. Tap the map to set the location manually.',
        );
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showLocationMessage(
          'Location permission denied. Tap the map to set the location manually.',
        );
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      final newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        customerLocation = newLocation;
      });
      mapController?.animateCamera(
        CameraUpdate.newLatLng(newLocation),
      );
    } catch (e) {
      _showLocationMessage(
        'Could not get current location. Tap the map to set it manually.',
      );
    }
  }
  void _showLocationMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  Future<void> pickImage(String type) async {
  final picker = ImagePicker();

  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder: (context) => SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(
                context,
                ImageSource.camera,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(
                context,
                ImageSource.gallery,
              );
            },
          ),
        ],
      ),
    ),
  );

  if (source == null) return;

  final pickedFile = await picker.pickImage(
    source: source,
  );

  if (pickedFile == null) return;

  setState(() {
    if (type == 'customer') {
      customerPhotoFile = File(pickedFile.path);
    } else if (type == 'address') {
      addressProofFile = File(pickedFile.path);
    } else if (type == 'id') {
      idProofFile = File(pickedFile.path);
    }
  });
}

  Widget buildField(
    String hint,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: TextField(
        controller: controller,

        style: const TextStyle(
          color: Colors.white,
        ),

        decoration: InputDecoration(
          hintText: hint,

          hintStyle: const TextStyle(
            color: Colors.white54,
          ),

          filled: true,
          fillColor: const Color(0xFF111827),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
    Widget uploadBox(
  String title,
  File? file,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 170,
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white24,
        ),
      ),
      child: file != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                file,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.upload_file,
                  color: Colors.white54,
                  size: 45,
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap to upload',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    final mobile = width < 700;

    return Scaffold(

      backgroundColor: const Color(0xFF020617),

      appBar: AppBar(

        backgroundColor: const Color(0xFF020617),

        title: const Text(
          "Add Customer",
          style: TextStyle(color: Colors.white),
        ),

      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              
const Text(
  "Work Address",
  style: TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 20),

if (mobile)

  Column(
    children: [

      buildField(
        "Company Name",
       companyController,
      ),
      buildField(
  "Office Address",
  officeAddressController,
),


      buildField(
        "Landmark",
        landmarkController,
      ),

      buildField(
        "Village / Area",
        villageController,
      ),

      buildField(
        "Taluk",
        talukController,
      ),

      buildField(
        "District",
        districtController,
      ),

      buildField(
        "State",
        stateController,
      ),

      buildField(
        "PIN Code",
        pincodeController,
      ),
    ],
  )

else

  Row(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [

      Expanded(
        child: Column(
          children: [

            buildField(
              "Company Name",
             companyController,
            ),

buildField(
  "Office Address",
  officeAddressController,
),

            buildField(
              "Village / Area",
              villageController,
            ),

            buildField(
              "District",
              districtController,
            ),

            buildField(
              "PIN Code",
              pincodeController,
            ),

          ],
        ),
      ),

      const SizedBox(width: 20),

      Expanded(
        child: Column(
          children: [

            buildField(
              "Landmark",
              landmarkController,
            ),

            buildField(
              "Taluk",
              talukController,
            ),

            buildField(
              "State",
              stateController,
            ),

          ],
        ),
      ),
    ],
  ),
              //const SizedBox(height: 30),
              const SizedBox(height: 20),

SizedBox(
  height: 320,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: GoogleMap(
      initialCameraPosition: CameraPosition(
        target: customerLocation,
        zoom: 14,
      ),
      onMapCreated: (controller) {
        mapController = controller;
      },
      onTap: (LatLng position) {
        setState(() {
          customerLocation = position;
        });
      },
      markers: {
        Marker(
          markerId: const MarkerId('customer'),
          position: customerLocation,
        ),
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
    ),
  ),
),

const SizedBox(height: 20),

Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: const Color(0xFF111827),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Selected Location",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        "Latitude : ${customerLocation.latitude}",
        style: const TextStyle(color: Colors.white70),
      ),
      Text(
        "Longitude : ${customerLocation.longitude}",
        style: const TextStyle(color: Colors.white70),
      ),
    ],
  ),
),

const SizedBox(height: 30),
const Text(
  "Photo Uploads",
  style: TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 20),

GridView.count(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisCount: mobile ? 1 : 2,
  crossAxisSpacing: 20,
  mainAxisSpacing: 20,
  childAspectRatio: 1.5,
  children: [

    

    uploadBox(
      'Work Address Proof',
      addressProofFile,
      () => pickImage('address'),
    ),

    

  ],
),

const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,

                height: 55,

                child: ElevatedButton(

                onPressed: () async {

  // Save Step 3 data into CustomerFormData
widget.formData.companyName = companyController.text;
widget.formData.officeAddress = officeAddressController.text;

widget.formData.workLandmark = landmarkController.text;
widget.formData.workVillage = villageController.text;
widget.formData.workTaluk = talukController.text;
widget.formData.workDistrict = districtController.text;
widget.formData.workState = stateController.text;
widget.formData.workPincode = pincodeController.text;

widget.formData.workLatitude = customerLocation.latitude;
widget.formData.workLongitude = customerLocation.longitude;

widget.formData.workAddressProof = addressProofFile;
print("===== STEP 3 =====");
print(widget.formData.companyName);
print(widget.formData.officeAddress);
print(widget.formData.workLandmark);
print(widget.formData.workVillage);
print(widget.formData.workDistrict);
print(widget.formData.workState);
print(widget.formData.workPincode);
print(widget.formData.workLatitude);
print(widget.formData.workLongitude);
// Call backend
final result = await AuthService.createCustomer(

  fullName: widget.formData.fullName,
  mobileNumber: widget.formData.mobileNumber,
  alternateNumber: widget.formData.alternateNumber,
  email: widget.formData.email,
  customerType: widget.formData.customerType,
  otherCustomerType:
      widget.formData.otherCustomerType,
  // Home Address
  houseName: widget.formData.homeHouseName,
  landmark: widget.formData.homeLandmark,
  village: widget.formData.homeVillage,
  taluk: widget.formData.homeTaluk,
  district: widget.formData.homeDistrict,
  state: widget.formData.homeState,
  pincode: widget.formData.homePincode,
  homeLatitude: widget.formData.homeLatitude ?? 0,
  homeLongitude: widget.formData.homeLongitude ?? 0,

  // Current Address
  currentHouseName: widget.formData.currentHouseName,
  currentLandmark: widget.formData.currentLandmark,
  currentVillage: widget.formData.currentVillage,
  currentTaluk: widget.formData.currentTaluk,
  currentDistrict: widget.formData.currentDistrict,
  currentState: widget.formData.currentState,
  currentPincode: widget.formData.currentPincode,
  currentLatitude: widget.formData.currentLatitude ?? 0,
  currentLongitude: widget.formData.currentLongitude ?? 0,

  // Work Address
  companyName: widget.formData.companyName,
  officeAddress: widget.formData.officeAddress,
  workLandmark: widget.formData.workLandmark,
  workVillage: widget.formData.workVillage,
  workTaluk: widget.formData.workTaluk,
  workDistrict: widget.formData.workDistrict,
  workState: widget.formData.workState,
  workPincode: widget.formData.workPincode,
  workLatitude: widget.formData.workLatitude ?? 0,
  workLongitude: widget.formData.workLongitude ?? 0,

  // Photos
  customerPhoto: widget.formData.customerPhoto,
  homeAddressProof: widget.formData.homeAddressProof,
  currentAddressProof: widget.formData.currentAddressProof,
  workAddressProof: widget.formData.workAddressProof,
  idProof: widget.formData.idProof,
);

if (result != null) {
  if (!mounted) return;

  Navigator.of(context).popUntil((route) => route.isFirst);
} else {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Failed to save customer"),
    ),
  );
}
  // We'll save to backend here next.

},

                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.blue,

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(16),

                    ),

                  ),

                  child: const Text(

                    "Save Customer",

                    style: TextStyle(

                      fontSize: 18,

                    ),

                  ),

                ),

              ),

            ],
          ),
        ),
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\screens\add_customer\customer_form_data.dart
```dart
import 'dart:io';

class CustomerFormData {
  //==========================
  // PERSONAL INFORMATION
  //==========================

  String fullName = '';
  String mobileNumber = '';
  String alternateNumber = '';
  String email = '';
  String customerType = 'Customer';
  String otherCustomerType = '';

  //==========================
  // HOME ADDRESS
  //==========================

  String homeHouseName = '';
  String homeBuildingName = '';
  String homeLandmark = '';
  String homeVillage = '';
  String homeTaluk = '';
  String homeDistrict = '';
  String homeState = '';
  String homePincode = '';

  double? homeLatitude;
  double? homeLongitude;

  //==========================
  // CURRENT ADDRESS
  //==========================

  String currentHouseName = '';
  String currentBuildingName = '';
  String currentLandmark = '';
  String currentVillage = '';
  String currentTaluk = '';
  String currentDistrict = '';
  String currentState = '';
  String currentPincode = '';

  double? currentLatitude;
  double? currentLongitude;

  //==========================
  // WORK ADDRESS
  //==========================

  String companyName = '';
  String officeAddress = '';

  String workLandmark = '';
  String workVillage = '';
  String workTaluk = '';
  String workDistrict = '';
  String workState = '';
  String workPincode = '';

  double? workLatitude;
  double? workLongitude;

  //==========================
  // PHOTOS
  //==========================

  File? customerPhoto;

  File? homeAddressProof;

  File? currentAddressProof;

  File? workAddressProof;

  File? idProof;
}
```

----------------------------------------

### File: chitty_mobile\lib\services\auth_service.dart
```dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  
  
   static const String baseUrl =
      //'https://chittyapi.orianacare.com/api';
      //'http://10.173.97.225:8000/api';
      'http://10.72.160.225:8000/api';
  
  static Future<List<dynamic>> getCustomers() async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('access_token');

  final response = await http.get(
    Uri.parse('$baseUrl/customers/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print("CUSTOMERS RESPONSE:");
  print(response.body);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  return [];
}

  static Future<Map<String, dynamic>> login({

    required String username,
    required String password,

  }) async {

    final response = await http.post(

      Uri.parse('$baseUrl/token/'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({

        'username': username,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        'access_token',
        data['access'],
      );

      await prefs.setString(
        'refresh_token',
        data['refresh'],
      );

      await prefs.setString(
        'role',
        data['role'],
      );
      print("ROLE = ${data['role']}");

      return {
        'success': true,
        'role': data['role'],
      };
    }

    return {
      'success': false,
      'message':
          data['detail'] ??
              'Login failed',
    };
  }

  static Future<void> logout() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();
  }
  static Future<List<dynamic>> getRecentCustomers() async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('access_token');

  final response = await http.get(

    Uri.parse(
      '$baseUrl/dashboard/recent-customers/',
    ),

    headers: {
      'Authorization':
          'Bearer $token',
    },
  );

  if (response.statusCode == 200) {

    return jsonDecode(
      response.body,
    );
  }

  return [];
}

static Future<List<dynamic>> getRecentSubscriptions() async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('access_token');

  final response = await http.get(

    Uri.parse(
      '$baseUrl/dashboard/recent-subscriptions/',
    ),

    headers: {
      'Authorization':
          'Bearer $token',
    },
  );

  if (response.statusCode == 200) {

    return jsonDecode(
      response.body,
    );
  }

  return [];
}
static Future<Map<String, dynamic>?> createCustomer({
  required String fullName,
  required String mobileNumber,
  required String alternateNumber,
  required String email,
  required String customerType,
  required String otherCustomerType,
  /*required String houseName,
  required String landmark,
  required String village,
  required String taluk,
  required String district,
  required String state,
  required String pincode,*/

  // Home Address
required String houseName,
required String landmark,
required String village,
required String taluk,
required String district,
required String state,
required String pincode,
required double homeLatitude,
required double homeLongitude,

// Current Address
required String currentHouseName,
required String currentLandmark,
required String currentVillage,
required String currentTaluk,
required String currentDistrict,
required String currentState,
required String currentPincode,
required double currentLatitude,
required double currentLongitude,

// Work Address
required String companyName,
required String officeAddress,
required String workLandmark,
required String workVillage,
required String workTaluk,
required String workDistrict,
required String workState,
required String workPincode,
required double workLatitude,
required double workLongitude,

// Photos
File? customerPhoto,
File? homeAddressProof,
File? currentAddressProof,
File? workAddressProof,
File? idProof,


}) async {

  final prefs =
      await SharedPreferences.getInstance();
  

  final token =
    prefs.getString('access_token');

  var request = http.MultipartRequest(
  'POST',
  Uri.parse('$baseUrl/customers/'),
);

request.headers['Authorization'] =
    'Bearer $token';

request.fields['full_name'] = fullName;
request.fields['mobile_number'] = mobileNumber;
request.fields['alternate_number'] = alternateNumber;
request.fields['email'] = email;
request.fields['customer_type'] =
    customerType == "Other"
        ? otherCustomerType
        : customerType;

request.fields['home_address'] = jsonEncode({
  'house_name': houseName,
  'building_name': '',
  'landmark': landmark,
  'village': village,
  'taluk': taluk,
  'district': district,
  'state': state,
  'pincode': pincode,
  'latitude': homeLatitude,
  'longitude': homeLongitude,
});
request.fields['current_address'] = jsonEncode({
  'house_name': currentHouseName,
  'building_name': '',
  'landmark': currentLandmark,
  'village': currentVillage,
  'taluk': currentTaluk,
  'district': currentDistrict,
  'state': currentState,
  'pincode': currentPincode,
  'latitude': currentLatitude,
  'longitude': currentLongitude,
});

request.fields['work_address'] = jsonEncode({
  'building_name': companyName,
  'house_name': officeAddress,
  'landmark': workLandmark,
  'village': workVillage,
  'taluk': workTaluk,
  'district': workDistrict,
  'state': workState,
  'pincode': workPincode,
  'latitude': workLatitude,
  'longitude': workLongitude,
});

if (customerPhoto != null) {
  request.files.add(
    await http.MultipartFile.fromPath(
      'customer_photo',
      customerPhoto.path,
    ),
  );
}

if (homeAddressProof != null) {
  request.files.add(
    await http.MultipartFile.fromPath(
      'address_proof',
      homeAddressProof.path,
    ),
  );
}

if (currentAddressProof != null) {
  request.files.add(
    await http.MultipartFile.fromPath(
      'current_address_proof',
      currentAddressProof.path,
    ),
  );
}

if (workAddressProof != null) {
  request.files.add(
    await http.MultipartFile.fromPath(
      'work_address_proof',
      workAddressProof.path,
    ),
  );
}

if (idProof != null) {
  request.files.add(
    await http.MultipartFile.fromPath(
      'id_proof',
      idProof.path,
    ),
  );
}
print("===== REQUEST DATA =====");
print(request.fields);

for (var file in request.files) {
  print("FILE: ${file.field}");
}
request.fields['customer_type'] = customerType;
final streamedResponse = await request.send();

final response =
    await http.Response.fromStream(
  streamedResponse,
);

print("Status Code: ${response.statusCode}");
print("Response: ${response.body}");

if (response.statusCode == 201) {
  return jsonDecode(response.body)
      as Map<String, dynamic>;
}

return null;
}
static Future<bool> deleteCustomer(
  int customerId,
) async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('access_token');

  final response = await http.delete(

    Uri.parse(
      '$baseUrl/customers/$customerId/',
    ),

    headers: {
      'Authorization':
          'Bearer $token',
    },
  );

  return response.statusCode == 204;
}
static Future<bool> updateCustomer({
  required int customerId,
  required String fullName,
  required String mobileNumber,
  required String alternateNumber,
  required String email,

  // Home Address
required String houseName,
required String landmark,
required String village,
required String taluk,
required String district,
required String state,
required String pincode,

// Current Address
required String currentHouseName,
required String currentBuildingName,
required String currentLandmark,
required String currentVillage,
required String currentTaluk,
required String currentDistrict,
required String currentState,
required String currentPincode,

// Work Address
required String companyName,
required String officeAddress,
required String officeLandmark,
required String workVillage,
required String workTaluk,
required String workDistrict,
required String workState,
required String workPincode,
}) async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('access_token');

  final response = await http.put(

    Uri.parse(
      '$baseUrl/customers/$customerId/',
    ),

    headers: {

      'Authorization':
          'Bearer $token',

      'Content-Type':
          'application/json',
    },

    body: jsonEncode({

      'full_name': fullName,

      'mobile_number': mobileNumber,

      'alternate_number': alternateNumber,

      'email': email,

      'home_address': {

        'house_name': houseName,

        'landmark': landmark,

        'village': village,

        'taluk': taluk,

        'district': district,

        'state': state,

        'pincode': pincode,
      },
      'current_address': {

  'house_name': currentHouseName,

  'building_name': currentBuildingName,

  'landmark': currentLandmark,

  'village': currentVillage,

  'taluk': currentTaluk,

  'district': currentDistrict,

  'state': currentState,

  'pincode': currentPincode,
},

'work_address': {

  'building_name': companyName,

  'house_name': officeAddress,

  'landmark': officeLandmark,

  'village': workVillage,

  'taluk': workTaluk,

  'district': workDistrict,

  'state': workState,

  'pincode': workPincode,
},
    }),
  );

  //print(response.statusCode);
  //print(response.body);
  print("Status Code: ${response.statusCode}");
  print("Response: ${response.body}");
  return response.statusCode == 200;
}
static Future<List<dynamic>> getChitPlans() async {

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final response = await http.get(
    Uri.parse('$baseUrl/chit-plans/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  return [];
}

static Future<List<dynamic>> getSubscriptions() async {

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final response = await http.get(
    Uri.parse('$baseUrl/subscriptions/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  return [];
}

static Future<bool> createSubscription({
  required int customerId,
  required int chitPlanId,
  required String joinedDate,
}) async {

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final response = await http.post(
    Uri.parse('$baseUrl/subscriptions/'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'customer': customerId,
      'chit_plan': chitPlanId,
      'joined_date': joinedDate,
    }),
  );

  print("Subscription Status Code: ${response.statusCode}");
  print("Subscription Response: ${response.body}");

  return response.statusCode == 201;
}
static Future<bool> createEmployee({
  required String fullName,
  required String username,
  required String email,
  required String password,
  required String role,
  required String phoneNumber,
}) async {

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final response = await http.post(
    Uri.parse('$baseUrl/employees/'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'full_name': fullName,
      'username': username,
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
      'role': role,
    }),
  );

  print(response.statusCode);
  print(response.body);

  return response.statusCode == 201;
}
static Future<List<dynamic>> getEmployees() async {

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  final response = await http.get(
    Uri.parse('$baseUrl/employees/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  print("EMPLOYEES API:");
  print(response.body);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  return [];
}
static Future<bool> toggleEmployeeStatus(
  int employeeId,
) async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('access_token');

  final response = await http.post(

    Uri.parse(
      '$baseUrl/employees/$employeeId/toggle_status/',
    ),

    headers: {
      'Authorization':
          'Bearer $token',
    },
  );

  print(response.body);

  return response.statusCode == 200;
}
static Future<bool> updateEmployee({
  required int employeeId,
  required String fullName,
  required String email,
  required String phoneNumber,
  required String role,
}) async {

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('access_token');

  final response = await http.put(

    Uri.parse(
      '$baseUrl/employees/$employeeId/',
    ),

    headers: {
      'Authorization':
          'Bearer $token',
      'Content-Type':
          'application/json',
    },

    body: jsonEncode({

      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,

    }),
  );

  print(response.body);
  print("UPDATE STATUS: ${response.statusCode}");
  print("UPDATE BODY: ${response.body}");
  return response.statusCode == 200;
}
static Future<Map<String, dynamic>> getAgentDashboard() async {
  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('access_token');

  final response = await http.get(
    Uri.parse('$baseUrl/agent-dashboard/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print("AGENT DASHBOARD:");
  print(response.body);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  return {};
}
static Future<bool> approveCustomer(int customerId) async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('access_token');

  final response = await http.post(
    Uri.parse('$baseUrl/customers/$customerId/approve/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  return response.statusCode == 200;
}
static Future<String?> getRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('role');
}
}
```

----------------------------------------

### File: chitty_mobile\lib\services\dashboard_service.dart
```dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

class DashboardService {
  static Future<Map<String, dynamic>> getStats() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('${AuthService.baseUrl}/dashboard/stats/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load dashboard stats');
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\widgets\chit_plan_dialog.dart
```dart
import 'package:flutter/material.dart';

class ChitPlanDialog extends StatelessWidget {
  const ChitPlanDialog({super.key});

  Widget field(String hint) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: TextField(

        style: const TextStyle(
          color: Colors.white,
        ),

        decoration: InputDecoration(

          hintText: hint,

          hintStyle: const TextStyle(
            color: Colors.white54,
          ),

          filled: true,
          fillColor: const Color(0xFF0F172A),

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(16),

            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(

      backgroundColor: Colors.transparent,

      child: Container(

        width: 500,

        padding: const EdgeInsets.all(28),

        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(24),
        ),

        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  const Text(
                    'Create Chit Plan',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  IconButton(

                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                children: [

                  Expanded(
                    child:
                        field('Plan Name'),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child:
                        field('Plan Code'),
                  ),
                ],
              ),

              field('Total Amount'),

              Row(
                children: [

                  Expanded(
                    child: field(
                      'Number of Installments',
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: field(
                      'Monthly Payment',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,

                children: [

                  OutlinedButton(

                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text(
                      'Cancel',
                    ),
                  ),

                  const SizedBox(width: 18),

                  ElevatedButton(

                    onPressed: () {},

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue,
                    ),

                    child: const Text(
                      'Create Plan',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\widgets\dashboard_card.dart
```dart
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(24),

        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),

        border: Border.all(
          color: Colors.white10,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\widgets\employee_dialog.dart
```dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
class EmployeeDialog extends StatefulWidget {

  final Map<String, dynamic>? employee;

  const EmployeeDialog({
    super.key,
    this.employee,
  });

  bool get isEdit =>
      employee != null;

  @override
  State<EmployeeDialog> createState() =>
      _EmployeeDialogState();
}
class _EmployeeDialogState
    extends State<EmployeeDialog> {

  String role = 'Admin';
  final fullNameController =
      TextEditingController();

  final usernameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final passwordController =
      TextEditingController();
  @override
  void initState() {
    super.initState();

    if (widget.employee != null) {

      fullNameController.text =
          widget.employee!['full_name_display'] ?? '';

      emailController.text =
          widget.employee!['email_display'] ?? '';

      phoneController.text =
          widget.employee!['phone_number'] ?? '';

      role =
          widget.employee!['role'] == 'admin'
              ? 'Admin'
              : 'Field Agent';
    }
  }


  Widget field(
  String hint,
  TextEditingController controller,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),

    child: TextField(
      controller: controller,

      style: const TextStyle(
        color: Colors.white,
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: const TextStyle(
          color: Colors.white54,
        ),

        filled: true,
        fillColor: const Color(0xFF0F172A),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),

          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {

    return Dialog(

      backgroundColor: Colors.transparent,

      child: Container(

        width: 500,

        padding: const EdgeInsets.all(28),

        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(24),
        ),

        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  Text(
  widget.isEdit
      ? 'Edit Employee'
      : 'Add Employee',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  IconButton(

                    onPressed: () {
                      Navigator.pop(context, true);
                    },

                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              field(
  'Full Name',
  fullNameController,
),

if (!widget.isEdit)
  field(
    'Username',
    usernameController,
  ),

field(
  'Email Address',
  emailController,
),

field(
  'Phone Number',
  phoneController,
),
if (!widget.isEdit)
  field(
    'Password',
    passwordController,
  ),

              const SizedBox(height: 10),

              const Text(
                'Role',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [

                  Expanded(
                    child: RadioListTile(

                      value: 'Admin',
                      groupValue: role,

                      activeColor: Colors.blue,

                      title: const Text(
                        'Admin',

                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      onChanged: (value) {

                        setState(() {

                          role = value!;
                        });
                      },
                    ),
                  ),

                  Expanded(
                    child: RadioListTile(

                      value: 'Field Agent',
                      groupValue: role,

                      activeColor: Colors.purple,

                      title: const Text(
                        'Field Agent',

                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      onChanged: (value) {

                        setState(() {

                          role = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              field(
  'Password',
  passwordController,
),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,

                children: [

                  OutlinedButton(

                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text(
                      'Cancel',
                    ),
                  ),

                  const SizedBox(width: 18),

                  ElevatedButton(

                    onPressed: () async {

  bool success;

  if (widget.isEdit) {

    success =
        await AuthService.updateEmployee(

      employeeId:
          widget.employee!['id'],

      fullName:
          fullNameController.text,

      email:
          emailController.text,

      phoneNumber:
          phoneController.text,

      role: role == 'Admin'
          ? 'admin'
          : 'field_agent',
    );

  } else {

    success =
        await AuthService.createEmployee(

      fullName:
          fullNameController.text,

      username:
          usernameController.text,

      email:
          emailController.text,

      password:
          passwordController.text,

      phoneNumber:
          phoneController.text,

      role: role == 'Admin'
          ? 'admin'
          : 'field_agent',
    );
  }

  if (success) {

    Navigator.pop(context, true);

  } else {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text('Operation Failed'),
      ),
    );
  }
},

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue,
                    ),

                    child: const Text(
                      'Add Employee',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\widgets\info_container.dart
```dart
import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {

  final String title;
  final Widget child;

  const InfoContainer({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(24),

        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.03),
          ],
        ),

        border: Border.all(
          color: Colors.white10,
        ),
      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\widgets\sidebar.dart
```dart
import 'package:flutter/material.dart';
import '../screens/subscriptions_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/customers_screen.dart';
import '../screens/employees_screen.dart';
import '../screens/chit_plans_screen.dart';
import '../screens/login_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/settings_screen.dart';
class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  Widget menuItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget screen, {
    bool active = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => screen,
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),

        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF1E3A8A)
              : Colors.transparent,

          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          children: [

            Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),

            const SizedBox(width: 14),

            Text(
              title,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      width: 260,

      padding: const EdgeInsets.all(20),

      decoration: const BoxDecoration(
        color: Color(0xFF081028),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          /// LOGO
          Row(
            children: [

              Container(
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius:
                      BorderRadius.circular(18),
                ),

                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 14),

              const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    'ChittyFinance',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    'Admin Panel',

                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 40),

          /// DASHBOARD
          menuItem(
            context,
            Icons.dashboard,
            'Dashboard',
            const DashboardScreen(),
          ),

          /// CUSTOMERS
          menuItem(
            context,
            Icons.people,
            'Customers',
            const CustomersScreen(),
          ),

          /// EMPLOYEES
          menuItem(
            context,
            Icons.badge,
            'Employees',
            const EmployeesScreen(),
          ),

          /// CHIT PLANS
          menuItem(
            context,
            Icons.description,
            'Chit Plans',
            const ChitPlansScreen(),
          ),

          /// SUBSCRIPTIONS
          menuItem(
  context,
  Icons.subscriptions,
  'Subscriptions',
  const SubscriptionsScreen(),
),

          /// REPORTS
          menuItem(
            context,
            Icons.bar_chart,
            'Reports',
            const ReportsScreen(),
          ),

          /// SETTINGS
          menuItem(
            context,
            Icons.settings,
            'Settings',
            const SettingsScreen(),
          ),

          const Spacer(),

          /// ADMIN SECTION
          Container(

            padding: const EdgeInsets.only(top: 20),

            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color:
                      Colors.white.withOpacity(0.08),
                ),
              ),
            ),

            child: Column(
              children: [

                /// ADMIN INFO
                Row(
                  children: [

                    CircleAvatar(
                      radius: 22,

                      backgroundColor:
                          Colors.greenAccent,

                      child: const Text(
                        'A',

                        style: TextStyle(
                          color: Colors.black,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Text(
                      'Admin',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// BUTTONS
                Row(
                  children: [

                    /// THEME BUTTON
                    Expanded(
                      child: Container(
                        height: 50,

                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF334155),

                          borderRadius:
                              BorderRadius.circular(
                                  12),
                        ),

                        child: IconButton(
                          onPressed: () {},

                          icon: const Icon(
                            Icons.dark_mode,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// LOGOUT BUTTON
                    Expanded(
                      child: InkWell(

                        onTap: () {

                          Navigator.pushAndRemoveUntil(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  const LoginScreen(),
                            ),

                            (route) => false,
                          );
                        },

                        child: Container(
                          height: 50,

                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF3B1D2E),

                            borderRadius:
                                BorderRadius.circular(
                                    12),
                          ),

                          child: const Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [

                              Icon(
                                Icons.logout,
                                color: Colors.redAccent,
                                size: 20,
                              ),

                              SizedBox(width: 8),

                              Text(
                                'Logout',

                                style: TextStyle(
                                  color:
                                      Colors.redAccent,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

----------------------------------------

### File: chitty_mobile\lib\widgets\subscription_dialog.dart
```dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SubscriptionDialog extends StatefulWidget {
  const SubscriptionDialog({super.key});

  @override
  State<SubscriptionDialog> createState() =>
      _SubscriptionDialogState();
}

class _SubscriptionDialogState
    extends State<SubscriptionDialog> {
  int? selectedCustomerId;
  int? selectedPlanId;

  List<dynamic> customers = [];
  List<dynamic> plans = [];
  bool isLoading = true;
  String? errorMessage;

  final TextEditingController
      dateController =
      TextEditingController(
    text: '09-06-2026',
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedCustomers = await AuthService.getCustomers();
      final fetchedPlans = await AuthService.getChitPlans();

      setState(() {
        customers = fetchedCustomers;
        plans = fetchedPlans;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data';
        isLoading = false;
      });
    }
  }

  Widget dropdownField({
    required String hint,
    required List<dynamic> items,
    required String labelKey,
    required int? value,
    required Function(int?) onChanged,
  }) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          dropdownColor: const Color(0xFF0F172A),
          hint: Text(
            hint,
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item['id'] as int,
              child: Text(
                (item[labelKey] ?? '').toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(

      backgroundColor: Colors.transparent,

      child: Container(

        width: 500,

        padding: const EdgeInsets.all(28),

        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(24),
        ),

        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  const Text(
                    'Enroll Customer in Chit Plan',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  IconButton(

                    onPressed: () {
                      Navigator.pop(context, null);
                    },

                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (errorMessage != null)
                Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Customer',

                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    dropdownField(
                      hint: 'Choose customer...',
                      items: customers,
                      labelKey: 'full_name',
                      value: selectedCustomerId,

                      onChanged: (value) {
                        setState(() {
                          selectedCustomerId = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Select Chit Plan',

                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    dropdownField(
                      hint: 'Choose plan...',
                      items: plans,
                      labelKey: 'chit_name',
                      value: selectedPlanId,

                      onChanged: (value) {
                        setState(() {
                          selectedPlanId = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),

              const Text(
                'Joined Date',

                style: TextStyle(
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              TextField(

                controller: dateController,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: InputDecoration(

                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    color: Colors.white70,
                  ),

                  filled: true,
                  fillColor:
                      const Color(0xFF0F172A),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),

                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,

                children: [

                  OutlinedButton(

                    onPressed: () {
                      Navigator.pop(context, null);
                    },

                    child: const Text(
                      'Cancel',
                    ),
                  ),

                  const SizedBox(width: 18),

                  ElevatedButton(
onPressed:
    selectedPlanId == null ||
            selectedCustomerId == null
        ? null
        : () async {
            await _enrollNow();
          },

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue,
                    ),

                    child: const Text(
                      'Enroll Now',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _enrollNow() async {
  if (selectedCustomerId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a customer'),
      ),
    );
    return;
  }

  if (selectedPlanId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a chit plan'),
      ),
    );
    return;
  }

  final dateText = dateController.text.trim();

  String isoDate = dateText;

  final match =
      RegExp(r'^(\d{2})-(\d{2})-(\d{4})$')
          .firstMatch(dateText);

  if (match != null) {
    final day = match.group(1);
    final month = match.group(2);
    final year = match.group(3);

    isoDate = '$year-$month-$day';
  }

  final success =
      await AuthService.createSubscription(
    customerId: selectedCustomerId!,
    chitPlanId: selectedPlanId!,
    joinedDate: isoDate,
  );

  if (success) {
    Navigator.pop(context, true);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to create subscription'),
      ),
    );
  }
}
}
```

----------------------------------------

### File: chitty_mobile\web\manifest.json
```json
{
    "name": "chitty_mobile",
    "short_name": "chitty_mobile",
    "start_url": ".",
    "display": "standalone",
    "background_color": "#0175C2",
    "theme_color": "#0175C2",
    "description": "A new Flutter project.",
    "orientation": "portrait-primary",
    "prefer_related_applications": false,
    "icons": [
        {
            "src": "icons/Icon-192.png",
            "sizes": "192x192",
            "type": "image/png"
        },
        {
            "src": "icons/Icon-512.png",
            "sizes": "512x512",
            "type": "image/png"
        },
        {
            "src": "icons/Icon-maskable-192.png",
            "sizes": "192x192",
            "type": "image/png",
            "purpose": "maskable"
        },
        {
            "src": "icons/Icon-maskable-512.png",
            "sizes": "512x512",
            "type": "image/png",
            "purpose": "maskable"
        }
    ]
}

```

----------------------------------------

### File: src\App.tsx
```tsx
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './hooks/useAuth';
import { ThemeProvider } from './hooks/useTheme';

// Layouts
import AdminLayout from './components/layout/AdminLayout';
import AgentLayout from './components/layout/AgentLayout';

// Pages
import LoginPage from './pages/LoginPage';
// Admin Pages
import Dashboard from './pages/admin/Dashboard';
import CustomersPage from './pages/admin/CustomersPage';
import CustomerFormPage from './pages/admin/CustomerFormPage';
import CustomerDetailPage from './pages/admin/CustomerDetailPage';
import ChitPlansPage from './pages/admin/ChitPlansPage';
import SubscriptionsPage from './pages/admin/SubscriptionsPage';
import EmployeesPage from './pages/admin/EmployeesPage';
import ReportsPage from './pages/admin/ReportsPage';
import SettingsPage from './pages/admin/SettingsPage';
// Agent Pages
import MyCustomersPage from './pages/agent/MyCustomersPage';
import AddCustomerPage from './pages/agent/AddCustomerPage';
import EnrollPage from './pages/agent/EnrollPage';
import AgentCustomerDetailPage from './pages/agent/CustomerDetailPage';

function LoadingScreen() {
  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
    </div>
  );
}

function ProtectedRoute({
  children,
  role,
}: {
  children: React.ReactNode;
  role?: 'admin' | 'agent';
}) {
  const { isAuthenticated, user, isLoading } = useAuth();

  if (isLoading) {
    return <LoadingScreen />;
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  if (role && user?.role !== role) {
    return <Navigate to={user?.role === 'admin' ? '/admin' : '/agent'} replace />;
  }

  return <>{children}</>;
}

function GuestRoute({ children }: { children: React.ReactNode }) {
  const { isAuthenticated, user, isLoading } = useAuth();

  if (isLoading) {
    return <LoadingScreen />;
  }

  if (isAuthenticated && user) {
    return <Navigate to={user.role === 'admin' ? '/admin' : '/agent'} replace />;
  }

  return <>{children}</>;
}

function AppRoutes() {
  return (
    <Routes>
      {/* Public Routes */}
      <Route path="/login" element={<GuestRoute><LoginPage /></GuestRoute>} />
      <Route path="/" element={<Navigate to="/login" replace />} />

      {/* Admin Routes */}
      <Route
        path="/admin"
        element={
          <ProtectedRoute role="admin">
            <AdminLayout />
          </ProtectedRoute>
        }
      >
        <Route index element={<Dashboard />} />
        <Route path="customers" element={<CustomersPage />} />
        <Route path="customers/add" element={<CustomerFormPage />} />
        <Route path="customers/edit/:id" element={<CustomerFormPage />} />
        <Route path="customers/:id" element={<CustomerDetailPage />} />
        <Route path="plans" element={<ChitPlansPage />} />
        <Route path="plans/add" element={<ChitPlansPage />} />
        <Route path="subscriptions" element={<SubscriptionsPage />} />
        <Route path="employees" element={<EmployeesPage />} />
        <Route path="employees/add" element={<EmployeesPage />} />
        <Route path="reports" element={<ReportsPage />} />
        <Route path="settings" element={<SettingsPage />} />
      </Route>

      {/* Agent Routes */}
      <Route
        path="/agent"
        element={
          <ProtectedRoute role="agent">
            <AgentLayout />
          </ProtectedRoute>
        }
      >
        <Route index element={<MyCustomersPage />} />
        <Route path="customer/:id" element={<AgentCustomerDetailPage />} />
        <Route path="add-customer" element={<AddCustomerPage />} />
        <Route path="enroll" element={<EnrollPage />} />
      </Route>

      {/* Catch all - redirect to login */}
      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <ThemeProvider>
        <AuthProvider>
          <AppRoutes />
        </AuthProvider>
      </ThemeProvider>
    </BrowserRouter>
  );
}

```

----------------------------------------

### File: src\main.tsx
```tsx
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import App from './App.tsx';
import './index.css';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>
);

```

----------------------------------------

### File: src\vite-env.d.ts
```ts
/// <reference types="vite/client" />

```

----------------------------------------

### File: src\components\layout\AdminLayout.tsx
```tsx
import { Outlet, NavLink, useNavigate } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import { useTheme } from '../../hooks/useTheme';
import {
  LayoutDashboard,
  Users,
  UserCog,
  FileText,
  CreditCard,
  BarChart3,
  Settings,
  LogOut,
  Moon,
  Sun,
  Menu,
  X,
} from 'lucide-react';
import { useState } from 'react';

const navItems = [
  { to: '/admin', icon: LayoutDashboard, label: 'Dashboard', end: true },
  { to: '/admin/customers', icon: Users, label: 'Customers' },
  { to: '/admin/employees', icon: UserCog, label: 'Employees' },
  { to: '/admin/plans', icon: FileText, label: 'Chit Plans' },
  { to: '/admin/subscriptions', icon: CreditCard, label: 'Subscriptions' },
  { to: '/admin/reports', icon: BarChart3, label: 'Reports' },
  { to: '/admin/settings', icon: Settings, label: 'Settings' },
];

export default function AdminLayout() {
  const { user, logout } = useAuth();
  const { isDark, toggleTheme } = useTheme();
  const navigate = useNavigate();
  const [sidebarOpen, setSidebarOpen] = useState(false);

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-100 via-slate-50 to-blue-50 dark:from-slate-900 dark:via-slate-900 dark:to-slate-800">
      {/* Mobile sidebar overlay */}
      {sidebarOpen && (
        <div
          className="fixed inset-0 bg-black/50 z-40 lg:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      {/* Sidebar */}
      <aside
        className={`fixed top-0 left-0 h-full w-64 glass-sidebar z-50 transform transition-transform duration-300 ${
          sidebarOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'
        }`}
      >
        <div className="flex flex-col h-full">
          {/* Logo */}
          <div className="p-6 border-b border-slate-200/50 dark:border-slate-700/50">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-primary-500 to-primary-600 flex items-center justify-center shadow-lg shadow-primary-500/25">
                  <CreditCard className="w-5 h-5 text-white" />
                </div>
                <div>
                  <h1 className="font-bold text-lg text-slate-800 dark:text-white">
                    ChittyFinance
                  </h1>
                  <p className="text-xs text-slate-500 dark:text-slate-400">
                    Admin Panel
                  </p>
                </div>
              </div>
              <button
                onClick={() => setSidebarOpen(false)}
                className="lg:hidden p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
          </div>

          {/* Navigation */}
          <nav className="flex-1 p-4 space-y-1 overflow-y-auto scrollbar-thin">
            {navItems.map((item) => (
              <NavLink
                key={item.to}
                to={item.to}
                end={item.end}
                className={({ isActive }) =>
                  `nav-item ${isActive ? 'nav-item-active' : ''}`
                }
                onClick={() => setSidebarOpen(false)}
              >
                <item.icon className="w-5 h-5" />
                <span>{item.label}</span>
              </NavLink>
            ))}
          </nav>

          {/* User section */}
          <div className="p-4 border-t border-slate-200/50 dark:border-slate-700/50">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 rounded-full bg-gradient-to-br from-accent-400 to-accent-500 flex items-center justify-center text-white font-semibold">
                {user?.name?.charAt(0) || 'A'}
              </div>
              <div className="flex-1 min-w-0">
                <p className="font-medium text-slate-800 dark:text-white truncate">
                  {user?.name}
                </p>
                <p className="text-xs text-slate-500 dark:text-slate-400 truncate">
                  {user?.email}
                </p>
              </div>
            </div>
            <div className="flex gap-2">
              <button
                onClick={toggleTheme}
                className="flex-1 flex items-center justify-center gap-2 py-2 rounded-lg bg-slate-100 dark:bg-slate-700 hover:bg-slate-200 dark:hover:bg-slate-600 transition-colors"
              >
                {isDark ? (
                  <Sun className="w-4 h-4" />
                ) : (
                  <Moon className="w-4 h-4" />
                )}
              </button>
              <button
                onClick={handleLogout}
                className="flex-1 flex items-center justify-center gap-2 py-2 rounded-lg bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 hover:bg-red-100 dark:hover:bg-red-900/30 transition-colors"
              >
                <LogOut className="w-4 h-4" />
                <span className="text-sm font-medium">Logout</span>
              </button>
            </div>
          </div>
        </div>
      </aside>

      {/* Main content */}
      <main className="lg:ml-64 min-h-screen">
        {/* Mobile header */}
        <header className="lg:hidden sticky top-0 z-30 glass px-4 py-3 flex items-center justify-between">
          <button
            onClick={() => setSidebarOpen(true)}
            className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700"
          >
            <Menu className="w-5 h-5" />
          </button>
          <h1 className="font-bold text-slate-800 dark:text-white">
            ChittyFinance
          </h1>
          <button
            onClick={toggleTheme}
            className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700"
          >
            {isDark ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
          </button>
        </header>

        {/* Page content */}
        <div className="p-4 lg:p-6">
          <Outlet />
        </div>
      </main>
    </div>
  );
}

```

----------------------------------------

### File: src\components\layout\AgentLayout.tsx
```tsx
import { Outlet, NavLink, useNavigate } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import { Users, UserPlus, FileText, LogOut, Menu, X } from 'lucide-react';
import { useState } from 'react';

const navItems = [
  { to: '/agent', icon: Users, label: 'My Customers', end: true },
  { to: '/agent/add-customer', icon: UserPlus, label: 'Add Customer' },
  { to: '/agent/enroll', icon: FileText, label: 'Enroll' },
];

export default function AgentLayout() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [menuOpen, setMenuOpen] = useState(false);

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-100 via-slate-50 to-blue-50 dark:from-slate-900 dark:via-slate-900 dark:to-slate-800 pb-20">
      {/* Header */}
      <header className="sticky top-0 z-30 glass px-4 py-3">
        <div className="flex items-center justify-between max-w-lg mx-auto">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-primary-500 to-primary-600 flex items-center justify-center shadow-lg shadow-primary-500/25">
              <FileText className="w-5 h-5 text-white" />
            </div>
            <div>
              <h1 className="font-bold text-base text-slate-800 dark:text-white">
                ChittyFinance
              </h1>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                {user?.name}
              </p>
            </div>
          </div>
          <button
            onClick={() => setMenuOpen(!menuOpen)}
            className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700"
          >
            {menuOpen ? (
              <X className="w-5 h-5" />
            ) : (
              <Menu className="w-5 h-5" />
            )}
          </button>
        </div>

        {/* Dropdown menu */}
        {menuOpen && (
          <div className="absolute right-4 top-16 w-48 glass-card p-2 shadow-xl animate-scale-in">
            <div className="px-3 py-2 border-b border-slate-200/50 dark:border-slate-700/50 mb-2">
              <p className="text-sm font-medium text-slate-800 dark:text-white">
                {user?.name}
              </p>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                {user?.email}
              </p>
            </div>
            <button
              onClick={handleLogout}
              className="w-full flex items-center gap-3 px-3 py-2 rounded-lg text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors"
            >
              <LogOut className="w-4 h-4" />
              <span className="text-sm font-medium">Logout</span>
            </button>
          </div>
        )}
      </header>

      {/* Main content */}
      <main className="p-4 max-w-lg mx-auto">
        <Outlet />
      </main>

      {/* Bottom Navigation */}
      <nav className="fixed bottom-0 left-0 right-0 glass border-t border-slate-200/50 dark:border-slate-700/50 z-30">
        <div className="flex justify-around max-w-lg mx-auto py-2">
          {navItems.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.end}
              className={({ isActive }) =>
                `mobile-nav-item ${isActive ? 'mobile-nav-item-active' : ''}`
              }
            >
              <item.icon className="w-6 h-6" />
              <span className="text-xs font-medium">{item.label}</span>
            </NavLink>
          ))}
        </div>
      </nav>
    </div>
  );
}

```

----------------------------------------

### File: src\components\ui\AddressForm.tsx
```tsx
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

```

----------------------------------------

### File: src\components\ui\Badge.tsx
```tsx
import { ReactNode } from 'react';

interface BadgeProps {
  variant: 'success' | 'warning' | 'danger' | 'info' | 'default';
  children: ReactNode;
  className?: string;
}

export function Badge({ variant, children, className = '' }: BadgeProps) {
  const variants = {
    success: 'badge badge-success',
    warning: 'badge badge-warning',
    danger: 'badge badge-danger',
    info: 'badge badge-info',
    default: 'badge bg-slate-100 dark:bg-slate-700 text-slate-700 dark:text-slate-300',
  };

  return <span className={`${variants[variant]} ${className}`}>{children}</span>;
}

export function StatusBadge({ status }: { status: string }) {
  const statusMap: Record<string, { variant: BadgeProps['variant']; label: string }> = {
    active: { variant: 'success', label: 'Active' },
    completed: { variant: 'info', label: 'Completed' },
    paused: { variant: 'warning', label: 'Paused' },
    pending: { variant: 'warning', label: 'Pending' },
    paid: { variant: 'success', label: 'Paid' },
    overdue: { variant: 'danger', label: 'Overdue' },
  };

  const config = statusMap[status] || { variant: 'default', label: status };

  return <Badge variant={config.variant}>{config.label}</Badge>;
}

```

----------------------------------------

### File: src\components\ui\Card.tsx
```tsx
import { ReactNode } from 'react';

interface CardProps {
  children: ReactNode;
  className?: string;
  onClick?: () => void;
}

export function Card({ children, className = '', onClick }: CardProps) {
  return (
    <div
      className={`glass-card p-6 ${className}`}
      onClick={onClick}
    >
      {children}
    </div>
  );
}

interface StatCardProps {
  title: string;
  value: string | number;
  subtitle?: string;
  icon: ReactNode;
  trend?: { value: number; isPositive: boolean };
  color?: 'primary' | 'accent' | 'warning' | 'danger';
}

export function StatCard({ title, value, subtitle, icon, trend, color = 'primary' }: StatCardProps) {
  const colorClasses = {
    primary: 'from-primary-400 to-primary-500 shadow-primary-500/25',
    accent: 'from-accent-400 to-accent-500 shadow-accent-500/25',
    warning: 'from-amber-400 to-amber-500 shadow-amber-500/25',
    danger: 'from-red-400 to-red-500 shadow-red-500/25',
  };

  return (
    <div className="stat-card">
      <div className="flex items-start justify-between">
        <div className="flex-1">
          <p className="text-sm font-medium text-slate-500 dark:text-slate-400 mb-1">
            {title}
          </p>
          <p className="text-2xl lg:text-3xl font-bold text-slate-800 dark:text-white">
            {value}
          </p>
          {subtitle && (
            <p className="text-xs text-slate-400 dark:text-slate-500 mt-1">
              {subtitle}
            </p>
          )}
          {trend && (
            <div className="flex items-center gap-1 mt-2">
              <span
                className={`text-xs font-medium ${
                  trend.isPositive
                    ? 'text-green-600 dark:text-green-400'
                    : 'text-red-600 dark:text-red-400'
                }`}
              >
                {trend.isPositive ? '+' : '-'}{Math.abs(trend.value)}%
              </span>
              <span className="text-xs text-slate-400">vs last month</span>
            </div>
          )}
        </div>
        <div
          className={`w-12 h-12 rounded-xl bg-gradient-to-br ${colorClasses[color]} flex items-center justify-center text-white shadow-lg`}
        >
          {icon}
        </div>
      </div>
    </div>
  );
}

interface PageHeaderProps {
  title: string;
  subtitle?: string;
  action?: ReactNode;
}

export function PageHeader({ title, subtitle, action }: PageHeaderProps) {
  return (
    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
      <div>
        <h1 className="text-2xl lg:text-3xl font-bold text-slate-800 dark:text-white">
          {title}
        </h1>
        {subtitle && (
          <p className="text-slate-500 dark:text-slate-400 mt-1">
            {subtitle}
          </p>
        )}
      </div>
      {action && <div>{action}</div>}
    </div>
  );
}

```

----------------------------------------

### File: src\components\ui\Form.tsx
```tsx
import { InputHTMLAttributes, SelectHTMLAttributes, TextareaHTMLAttributes, forwardRef } from 'react';

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
  icon?: React.ReactNode;
}

export const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ label, error, icon, className = '', ...props }, ref) => {
    return (
      <div className="w-full">
        {label && <label className="form-label">{label}</label>}
        <div className="relative">
          {icon && (
            <div className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">
              {icon}
            </div>
          )}
          <input
            ref={ref}
            className={`glass-input w-full py-3 ${icon ? 'pl-10' : 'px-4'} ${
              error ? 'border-red-400 focus:border-red-500 focus:ring-red-500/20' : ''
            } ${className}`}
            {...props}
          />
        </div>
        {error && <p className="text-sm text-red-500 mt-1">{error}</p>}
      </div>
    );
  }
);

Input.displayName = 'Input';

interface SelectProps extends SelectHTMLAttributes<HTMLSelectElement> {
  label?: string;
  error?: string;
  options: { value: string; label: string }[];
}

export const Select = forwardRef<HTMLSelectElement, SelectProps>(
  ({ label, error, options, className = '', ...props }, ref) => {
    return (
      <div className="w-full">
        {label && <label className="form-label">{label}</label>}
        <select
          ref={ref}
          className={`glass-input w-full py-3 px-4 appearance-none cursor-pointer ${
            error ? 'border-red-400 focus:border-red-500 focus:ring-red-500/20' : ''
          } ${className}`}
          {...props}
        >
          {options.map((option) => (
            <option key={option.value} value={option.value}>
              {option.label}
            </option>
          ))}
        </select>
        {error && <p className="text-sm text-red-500 mt-1">{error}</p>}
      </div>
    );
  }
);

Select.displayName = 'Select';

interface TextareaProps extends TextareaHTMLAttributes<HTMLTextAreaElement> {
  label?: string;
  error?: string;
}

export const Textarea = forwardRef<HTMLTextAreaElement, TextareaProps>(
  ({ label, error, className = '', ...props }, ref) => {
    return (
      <div className="w-full">
        {label && <label className="form-label">{label}</label>}
        <textarea
          ref={ref}
          className={`glass-input w-full py-3 px-4 resize-none ${
            error ? 'border-red-400 focus:border-red-500 focus:ring-red-500/20' : ''
          } ${className}`}
          {...props}
        />
        {error && <p className="text-sm text-red-500 mt-1">{error}</p>}
      </div>
    );
  }
);

Textarea.displayName = 'Textarea';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'danger' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  isLoading?: boolean;
  icon?: React.ReactNode;
}

export function Button({
  children,
  variant = 'primary',
  size = 'md',
  isLoading = false,
  icon,
  className = '',
  disabled,
  ...props
}: ButtonProps) {
  const variants = {
    primary: 'glass-button',
    secondary: 'glass-button-secondary',
    danger: 'bg-gradient-to-r from-red-500 to-red-600 dark:from-red-400 dark:to-red-500 text-white font-semibold rounded-xl shadow-lg shadow-red-500/25 hover:shadow-xl hover:shadow-red-500/30 hover:-translate-y-0.5 active:translate-y-0 transition-all duration-200',
    ghost: 'text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700 font-medium rounded-xl transition-all duration-200',
  };

  const sizes = {
    sm: 'px-3 py-2 text-sm',
    md: 'px-4 py-3 text-sm',
    lg: 'px-6 py-4 text-base',
  };

  return (
    <button
      className={`${variants[variant]} ${sizes[size]} flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:transform-none ${className}`}
      disabled={disabled || isLoading}
      {...props}
    >
      {isLoading ? (
        <div className="w-5 h-5 border-2 border-current border-t-transparent rounded-full animate-spin" />
      ) : (
        <>
          {icon}
          {children}
        </>
      )}
    </button>
  );
}

```

----------------------------------------

### File: src\components\ui\Modal.tsx
```tsx
import { ReactNode, useEffect } from 'react';
import { X } from 'lucide-react';

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title?: string;
  children: ReactNode;
  size?: 'sm' | 'md' | 'lg' | 'xl' | 'full';
}

export function Modal({ isOpen, onClose, title, children, size = 'md' }: ModalProps) {
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';
    }
    return () => {
      document.body.style.overflow = 'unset';
    };
  }, [isOpen]);

  if (!isOpen) return null;

  const sizes = {
    sm: 'max-w-sm',
    md: 'max-w-md',
    lg: 'max-w-lg',
    xl: 'max-w-2xl',
    full: 'max-w-4xl',
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 animate-fade-in">
      <div
        className="absolute inset-0 bg-black/50 backdrop-blur-sm"
        onClick={onClose}
      />
      <div
        className={`relative w-full ${sizes[size]} glass-card p-6 animate-scale-in max-h-[90vh] overflow-y-auto scrollbar-thin`}
      >
        {title && (
          <div className="flex items-center justify-between mb-4 pb-4 border-b border-slate-200/50 dark:border-slate-700/50">
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
              {title}
            </h2>
            <button
              onClick={onClose}
              className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors"
            >
              <X className="w-5 h-5 text-slate-500" />
            </button>
          </div>
        )}
        {children}
      </div>
    </div>
  );
}

interface ConfirmDialogProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title: string;
  message: string;
  confirmText?: string;
  cancelText?: string;
  variant?: 'danger' | 'warning' | 'primary';
}

export function ConfirmDialog({
  isOpen,
  onClose,
  onConfirm,
  title,
  message,
  confirmText = 'Confirm',
  cancelText = 'Cancel',
  variant = 'danger',
}: ConfirmDialogProps) {
  if (!isOpen) return null;

  const variantClasses = {
    danger: 'bg-gradient-to-r from-red-500 to-red-600 text-white',
    warning: 'bg-gradient-to-r from-amber-500 to-amber-600 text-white',
    primary: 'glass-button',
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} size="sm">
      <h3 className="text-lg font-semibold text-slate-800 dark:text-white mb-2">
        {title}
      </h3>
      <p className="text-slate-600 dark:text-slate-300 mb-6">{message}</p>
      <div className="flex gap-3 justify-end">
        <button
          onClick={onClose}
          className="px-4 py-2 rounded-xl bg-slate-100 dark:bg-slate-700 text-slate-700 dark:text-slate-200 font-medium hover:bg-slate-200 dark:hover:bg-slate-600 transition-colors"
        >
          {cancelText}
        </button>
        <button
          onClick={() => {
            onConfirm();
            onClose();
          }}
          className={`px-4 py-2 rounded-xl font-medium ${variantClasses[variant]}`}
        >
          {confirmText}
        </button>
      </div>
    </Modal>
  );
}

```

----------------------------------------

### File: src\components\ui\PhotoUpload.tsx
```tsx
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

```

----------------------------------------

### File: src\components\ui\Table.tsx
```tsx
import { ReactNode } from 'react';
import { ChevronLeft, ChevronRight, ChevronsLeft, ChevronsRight } from 'lucide-react';
import { Button } from './Form';

interface Column<T> {
  key: keyof T | string;
  header: string;
  render?: (item: T) => ReactNode;
  className?: string;
}

interface TableProps<T> {
  columns: Column<T>[];
  data: T[];
  keyExtractor: (item: T) => string;
  onRowClick?: (item: T) => void;
  emptyMessage?: string;
}

export function Table<T>({
  columns,
  data,
  keyExtractor,
  onRowClick,
  emptyMessage = 'No data available',
}: TableProps<T>) {
  return (
    <div className="overflow-x-auto rounded-xl border border-slate-200/50 dark:border-slate-700/50">
      <table className="w-full">
        <thead>
          <tr className="bg-slate-50/80 dark:bg-slate-800/80 border-b border-slate-200/50 dark:border-slate-700/50">
            {columns.map((col) => (
              <th
                key={col.key as string}
                className={`px-4 py-3 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider ${
                  col.className || ''
                }`}
              >
                {col.header}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {data.length === 0 ? (
            <tr>
              <td
                colSpan={columns.length}
                className="px-4 py-12 text-center text-slate-500 dark:text-slate-400"
              >
                {emptyMessage}
              </td>
            </tr>
          ) : (
            data.map((item) => (
              <tr
                key={keyExtractor(item)}
                className={`table-row border-b border-slate-100 dark:border-slate-700/50 last:border-b-0 ${
                  onRowClick ? 'cursor-pointer' : ''
                }`}
                onClick={() => onRowClick?.(item)}
              >
                {columns.map((col) => (
                  <td
                    key={col.key as string}
                    className={`px-4 py-4 text-sm text-slate-700 dark:text-slate-300 ${
                      col.className || ''
                    }`}
                  >
                    {col.render
                      ? col.render(item)
                      : String(item[col.key as keyof T] ?? '')}
                  </td>
                ))}
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
}

interface PaginationProps {
  currentPage: number;
  totalPages: number;
  onPageChange: (page: number) => void;
}

export function Pagination({ currentPage, totalPages, onPageChange }: PaginationProps) {
  if (totalPages <= 1) return null;

  const pages = Array.from({ length: totalPages }, (_, i) => i + 1);

  return (
    <div className="flex items-center justify-between px-4 py-3 border-t border-slate-200/50 dark:border-slate-700/50">
      <p className="text-sm text-slate-500 dark:text-slate-400">
        Page {currentPage} of {totalPages}
      </p>
      <div className="flex items-center gap-1">
        <Button
          variant="ghost"
          size="sm"
          onClick={() => onPageChange(1)}
          disabled={currentPage === 1}
        >
          <ChevronsLeft className="w-4 h-4" />
        </Button>
        <Button
          variant="ghost"
          size="sm"
          onClick={() => onPageChange(currentPage - 1)}
          disabled={currentPage === 1}
        >
          <ChevronLeft className="w-4 h-4" />
        </Button>
        {pages.slice(Math.max(0, currentPage - 3), currentPage + 2).map((page) => (
          <Button
            key={page}
            variant={page === currentPage ? 'primary' : 'ghost'}
            size="sm"
            onClick={() => onPageChange(page)}
            className="min-w-[36px]"
          >
            {page}
          </Button>
        ))}
        <Button
          variant="ghost"
          size="sm"
          onClick={() => onPageChange(currentPage + 1)}
          disabled={currentPage === totalPages}
        >
          <ChevronRight className="w-4 h-4" />
        </Button>
        <Button
          variant="ghost"
          size="sm"
          onClick={() => onPageChange(totalPages)}
          disabled={currentPage === totalPages}
        >
          <ChevronsRight className="w-4 h-4" />
        </Button>
      </div>
    </div>
  );
}

interface SearchBarProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
}

export function SearchBar({ value, onChange, placeholder = 'Search...' }: SearchBarProps) {
  return (
    <div className="relative w-full max-w-md">
      <input
        type="text"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="glass-input w-full py-2.5 pl-10 pr-4 text-sm"
      />
      <svg
        className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path
          strokeLinecap="round"
          strokeLinejoin="round"
          strokeWidth={2}
          d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
        />
      </svg>
    </div>
  );
}

```

----------------------------------------

### File: src\data\mockData.ts
```ts
import { Customer, ChitPlan, Subscription, Employee, DashboardStats } from '../types';

export const mockDashboardStats: DashboardStats = {
  totalCustomers: 1247,
  activeChitties: 342,
  monthlyCollections: 2845000,
  pendingPayments: 567,
  activePlans: 15,
  recentOnboardings: 23,
};

export const mockChitPlans: ChitPlan[] = [
  {
    id: '1',
    planName: 'Gold Savings',
    planCode: 'GS-100',
    totalAmount: 100000,
    numberOfInstallments: 20,
    monthlyPayment: 5000,
    isActive: true,
    createdAt: '2024-01-15',
  },
  {
    id: '2',
    planName: 'Silver Savings',
    planCode: 'SS-50',
    totalAmount: 50000,
    numberOfInstallments: 25,
    monthlyPayment: 2000,
    isActive: true,
    createdAt: '2024-01-20',
  },
  {
    id: '3',
    planName: 'Diamond Premium',
    planCode: 'DP-200',
    totalAmount: 200000,
    numberOfInstallments: 40,
    monthlyPayment: 5000,
    isActive: true,
    createdAt: '2024-02-01',
  },
  {
    id: '4',
    planName: 'Bronze Basic',
    planCode: 'BB-25',
    totalAmount: 25000,
    numberOfInstallments: 25,
    monthlyPayment: 1000,
    isActive: false,
    createdAt: '2024-02-15',
  },
  {
    id: '5',
    planName: 'Platinum Elite',
    planCode: 'PE-500',
    totalAmount: 500000,
    numberOfInstallments: 50,
    monthlyPayment: 10000,
    isActive: true,
    createdAt: '2024-03-01',
  },
];

export const mockCustomers: Customer[] = [
  {
    id: '1',
    customerId: 'CF-2024-001',
    name: 'Rajesh Kumar',
    primaryMobile: '+91 9876543210',
    alternateMobile: '+91 8765432109',
    email: 'rajesh.kumar@email.com',
    homeAddress: {
      id: '1',
      type: 'home',
      houseOrBuildingName: 'Krishna Villa',
      landmark: 'Near Temple',
      village: 'Kothapeta',
      taluk: 'Kakinada',
      district: 'East Godavari',
      state: 'Andhra Pradesh',
      pinCode: '533003',
      latitude: 16.9876,
      longitude: 82.2412,
      mapUrl: 'https://maps.google.com/?q=16.9876,82.2412',
    },
    workAddress: {
      id: '2',
      type: 'work',
      houseOrBuildingName: 'Tech Park, Tower B',
      landmark: 'Hitech City',
      village: 'Madhapur',
      taluk: 'Serilingampally',
      district: 'Hyderabad',
      state: 'Telangana',
      pinCode: '500081',
      latitude: 17.4483,
      longitude: 78.3915,
      mapUrl: 'https://maps.google.com/?q=17.4483,78.3915',
    },
    photos: [
      { id: '1', type: 'customer', url: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=150', uploadedAt: '2024-03-15' },
      { id: '2', type: 'address_proof', url: 'https://images.pexels.com/photos/5458388/pexels-photo-5458388.jpeg?auto=compress&cs=tinysrgb&w=150', uploadedAt: '2024-03-15' },
      { id: '3', type: 'id_proof', url: 'https://images.pexels.com/photos/5699456/pexels-photo-5699456.jpeg?auto=compress&cs=tinysrgb&w=150', uploadedAt: '2024-03-15' },
    ],
    createdBy: 'agent_1',
    createdAt: '2024-03-15',
    updatedAt: '2024-03-15',
  },
  {
    id: '2',
    customerId: 'CF-2024-002',
    name: 'Lakshmi Devi',
    primaryMobile: '+91 7654321098',
    email: 'lakshmi.devi@email.com',
    homeAddress: {
      id: '3',
      type: 'home',
      houseOrBuildingName: 'Ganga Bhavan',
      landmark: 'Opposite School',
      village: 'Dwaraka Nagar',
      taluk: 'Vijayawada',
      district: 'Krishna',
      state: 'Andhra Pradesh',
      pinCode: '520010',
      latitude: 16.5062,
      longitude: 80.6480,
      mapUrl: 'https://maps.google.com/?q=16.5062,80.6480',
    },
    photos: [
      { id: '4', type: 'customer', url: 'https://images.pexels.com/photos/7749090/pexels-photo-7749090.jpeg?auto=compress&cs=tinysrgb&w=150', uploadedAt: '2024-03-18' },
      { id: '5', type: 'id_proof', url: 'https://images.pexels.com/photos/5699456/pexels-photo-5699456.jpeg?auto=compress&cs=tinysrgb&w=150', uploadedAt: '2024-03-18' },
    ],
    createdBy: 'agent_2',
    createdAt: '2024-03-18',
    updatedAt: '2024-03-18',
  },
  {
    id: '3',
    customerId: 'CF-2024-003',
    name: 'Venkat Rao',
    primaryMobile: '+91 6543210987',
    alternateMobile: '+91 5432109876',
    email: 'venkat.rao@email.com',
    homeAddress: {
      id: '4',
      type: 'home',
      houseOrBuildingName: 'Sai Residency, A-42',
      landmark: 'Near Bus Stand',
      village: 'MVP Colony',
      taluk: 'Visakhapatnam',
      district: 'Visakhapatnam',
      state: 'Andhra Pradesh',
      pinCode: '530017',
      latitude: 17.7231,
      longitude: 83.3013,
      mapUrl: 'https://maps.google.com/?q=17.7231,83.3013',
    },
    workAddress: {
      id: '5',
      type: 'work',
      houseOrBuildingName: 'Nexus Mall, Shop No. 15',
      landmark: 'Beach Road',
      village: 'RK Beach',
      taluk: 'Visakhapatnam',
      district: 'Visakhapatnam',
      state: 'Andhra Pradesh',
      pinCode: '530002',
      latitude: 17.7133,
      longitude: 83.3177,
      mapUrl: 'https://maps.google.com/?q=17.7133,83.3177',
    },
    photos: [
      { id: '6', type: 'customer', url: 'https://images.pexels.com/photos/2182970/pexels-photo-2182970.jpeg?auto=compress&cs=tinysrgb&w=150', uploadedAt: '2024-03-20' },
    ],
    createdBy: 'agent_1',
    createdAt: '2024-03-20',
    updatedAt: '2024-03-20',
  },
];

export const mockSubscriptions: Subscription[] = [
  {
    id: '1',
    customerId: '1',
    customerName: 'Rajesh Kumar',
    chitPlanId: '1',
    chitPlanName: 'Gold Savings',
    joinedDate: '2024-03-15',
    status: 'active',
    paymentStatus: 'paid',
    totalPaid: 25000,
    remainingAmount: 75000,
  },
  {
    id: '2',
    customerId: '2',
    customerName: 'Lakshmi Devi',
    chitPlanId: '2',
    chitPlanName: 'Silver Savings',
    joinedDate: '2024-03-18',
    status: 'active',
    paymentStatus: 'pending',
    totalPaid: 4000,
    remainingAmount: 46000,
  },
  {
    id: '3',
    customerId: '3',
    customerName: 'Venkat Rao',
    chitPlanId: '3',
    chitPlanName: 'Diamond Premium',
    joinedDate: '2024-03-20',
    status: 'active',
    paymentStatus: 'overdue',
    totalPaid: 15000,
    remainingAmount: 185000,
  },
  {
    id: '4',
    customerId: '1',
    customerName: 'Rajesh Kumar',
    chitPlanId: '2',
    chitPlanName: 'Silver Savings',
    joinedDate: '2024-02-01',
    status: 'completed',
    paymentStatus: 'paid',
    totalPaid: 50000,
    remainingAmount: 0,
  },
];

export const mockEmployees: Employee[] = [
  {
    id: '1',
    employeeId: 'EMP-001',
    userId: 'u1',
    username: 'ramesh.agent',
    name: 'Ramesh Sharma',
    email: 'ramesh@chittyfinance.com',
    phone: '+91 9123456789',
    role: 'agent',
    isActive: true,
    customersCount: 45,
    createdAt: '2024-01-15',
  },
  {
    id: '2',
    employeeId: 'EMP-002',
    userId: 'u2',
    username: 'suresh.agent',
    name: 'Suresh Reddy',
    email: 'suresh@chittyfinance.com',
    phone: '+91 9234567890',
    role: 'agent',
    isActive: true,
    customersCount: 67,
    createdAt: '2024-01-20',
  },
  {
    id: '3',
    employeeId: 'EMP-003',
    userId: 'u3',
    username: 'anitha.agent',
    name: 'Anitha Kumari',
    email: 'anitha@chittyfinance.com',
    phone: '+91 9345678901',
    role: 'agent',
    isActive: false,
    customersCount: 23,
    createdAt: '2024-02-01',
  },
  {
    id: '4',
    employeeId: 'EMP-004',
    userId: 'u4',
    username: 'vijay.agent',
    name: 'Vijay Prasad',
    email: 'vijay@chittyfinance.com',
    phone: '+91 9456789012',
    role: 'agent',
    isActive: true,
    customersCount: 89,
    createdAt: '2024-02-15',
  },
  {
    id: '5',
    employeeId: 'ADM-001',
    userId: 'u5',
    username: 'admin.user',
    name: 'Admin User',
    email: 'admin@chittyfinance.com',
    phone: '+91 9567890123',
    role: 'admin',
    isActive: true,
    customersCount: 0,
    createdAt: '2024-01-01',
  },
];

```

----------------------------------------

### File: src\hooks\useAuth.tsx
```tsx
import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { User } from '../types';
import {
  clearAuthData,
  getAccessToken,
  getStoredUser,
  login as apiLogin,
  mapApiError,
} from '../services/api';

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  login: (username: string, password: string) => Promise<User>;
  logout: () => void;
  isLoading: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const token = getAccessToken();
    const storedUser = getStoredUser();
    if (token && storedUser) {
      setUser(storedUser);
    } else {
      clearAuthData();
    }
    setIsLoading(false);
  }, []);

  const login = async (username: string, password: string): Promise<User> => {
    try {
      const loggedInUser = await apiLogin(username, password);
      setUser(loggedInUser);
      return loggedInUser;
    } catch (error) {
      throw new Error(mapApiError(error));
    }
  };

  const logout = () => {
    setUser(null);
    clearAuthData();
  };

  return (
    <AuthContext.Provider value={{ user, isAuthenticated: !!user, login, logout, isLoading }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}

```

----------------------------------------

### File: src\hooks\useTheme.tsx
```tsx
import { createContext, useContext, useState, useEffect, ReactNode } from 'react';

interface ThemeContextType {
  isDark: boolean;
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export function ThemeProvider({ children }: { children: ReactNode }) {
  const [isDark, setIsDark] = useState(() => {
    const stored = localStorage.getItem('chitty_theme');
    if (stored) return stored === 'dark';
    return window.matchMedia('(prefers-color-scheme: dark)').matches;
  });

  useEffect(() => {
    if (isDark) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
    localStorage.setItem('chitty_theme', isDark ? 'dark' : 'light');
  }, [isDark]);

  const toggleTheme = () => setIsDark(!isDark);

  return (
    <ThemeContext.Provider value={{ isDark, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  const context = useContext(ThemeContext);
  if (context === undefined) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return context;
}

```

----------------------------------------

### File: src\pages\LoginPage.tsx
```tsx
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import { useTheme } from '../hooks/useTheme';
import { Input, Button } from '../components/ui/Form';
import { CreditCard, Moon, Sun, User, Lock } from 'lucide-react';

export default function LoginPage() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');

  const { login } = useAuth();
  const { isDark, toggleTheme } = useTheme();
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setIsLoading(true);

    try {
      const user = await login(username, password);
      navigate(user.role === 'admin' ? '/admin' : '/agent');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-100 via-slate-50 to-blue-50 dark:from-slate-900 dark:via-slate-900 dark:to-slate-800 flex items-center justify-center p-4">
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-40 -right-40 w-80 h-80 bg-primary-500/10 rounded-full blur-3xl" />
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-accent-500/10 rounded-full blur-3xl" />
      </div>

      <button
        onClick={toggleTheme}
        className="absolute top-4 right-4 p-3 rounded-xl glass hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors"
      >
        {isDark ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
      </button>

      <div className="w-full max-w-md">
        <div className="glass-card p-8 animate-fade-in">
          <div className="flex flex-col items-center mb-8">
            <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-primary-500 to-primary-600 flex items-center justify-center shadow-lg shadow-primary-500/25 mb-4">
              <CreditCard className="w-8 h-8 text-white" />
            </div>
            <h1 className="text-2xl font-bold text-slate-800 dark:text-white">
              ChittyFinance
            </h1>
            <p className="text-slate-500 dark:text-slate-400 text-sm mt-1">
              Customer Management System
            </p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <Input
              label="Username"
              placeholder="Enter your username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              icon={<User className="w-4 h-4" />}
              required
            />

            <Input
              label="Password"
              type="password"
              placeholder="Enter your password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              icon={<Lock className="w-4 h-4" />}
              required
            />

            {error && (
              <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
                {error}
              </div>
            )}

            <Button type="submit" className="w-full" isLoading={isLoading}>
              {isLoading ? 'Signing in...' : 'Sign In'}
            </Button>
          </form>

          <div className="mt-6 pt-6 border-t border-slate-200/50 dark:border-slate-700/50">
            <p className="text-center text-xs text-slate-400 dark:text-slate-500">
              Sign in with your employee credentials. Your role determines the dashboard you see.
            </p>
          </div>
        </div>

        <p className="text-center text-xs text-slate-400 dark:text-slate-500 mt-4">
          Protected by JWT Authentication
        </p>
      </div>
    </div>
  );
}

```

----------------------------------------

### File: src\pages\admin\ChitPlansPage.tsx
```tsx
import { useCallback, useEffect, useState } from 'react';
import { Table, Pagination, SearchBar } from '../../components/ui/Table';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { StatusBadge } from '../../components/ui/Badge';
import { Modal } from '../../components/ui/Modal';
import { ChitPlan } from '../../types';
import { Plus, Edit, Power, IndianRupee, Calendar } from 'lucide-react';
import {
  createChitPlan,
  fetchChitPlans,
  mapApiError,
  toggleChitPlanActive,
  updateChitPlan,
} from '../../services/api';

const PAGE_SIZE = 10;

export default function ChitPlansPage() {
  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [plans, setPlans] = useState<ChitPlan[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editingPlan, setEditingPlan] = useState<ChitPlan | null>(null);
  const [formData, setFormData] = useState({
    planName: '',
    planCode: '',
    totalAmount: '',
    numberOfInstallments: '',
    monthlyPayment: '',
  });

  const loadPlans = useCallback(async () => {
    setIsLoading(true);
    setError('');
    try {
      const data = await fetchChitPlans(search ? { search } : {});
      setPlans(data);
      setCurrentPage(1);
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsLoading(false);
    }
  }, [search]);

  useEffect(() => {
    const timer = setTimeout(() => {
      loadPlans();
    }, 300);
    return () => clearTimeout(timer);
  }, [loadPlans]);

  const paginatedPlans = plans.slice((currentPage - 1) * PAGE_SIZE, currentPage * PAGE_SIZE);

  const handleOpenModal = (plan?: ChitPlan) => {
    if (plan) {
      setEditingPlan(plan);
      setFormData({
        planName: plan.planName,
        planCode: plan.planCode,
        totalAmount: plan.totalAmount.toString(),
        numberOfInstallments: plan.numberOfInstallments.toString(),
        monthlyPayment: plan.monthlyPayment.toString(),
      });
    } else {
      setEditingPlan(null);
      setFormData({
        planName: '',
        planCode: '',
        totalAmount: '',
        numberOfInstallments: '',
        monthlyPayment: '',
      });
    }
    setShowModal(true);
  };

  const handleSave = async () => {
    setIsSaving(true);
    setError('');
    try {
      const payload = {
        planName: formData.planName,
        planCode: formData.planCode,
        totalAmount: Number(formData.totalAmount),
        numberOfInstallments: Number(formData.numberOfInstallments),
        monthlyPayment: Number(formData.monthlyPayment),
      };

      if (editingPlan) {
        await updateChitPlan(editingPlan.id, {
          ...payload,
          isActive: editingPlan.isActive,
        });
      } else {
        await createChitPlan(payload);
      }

      setShowModal(false);
      await loadPlans();
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsSaving(false);
    }
  };

  const handleToggleActive = async (plan: ChitPlan) => {
    try {
      await toggleChitPlanActive(plan.id, !plan.isActive);
      await loadPlans();
    } catch (err) {
      setError(mapApiError(err));
    }
  };

  const columns = [
    {
      key: 'planName',
      header: 'Plan Name',
      render: (plan: ChitPlan) => (
        <div>
          <p className="font-medium text-slate-800 dark:text-white">{plan.planName}</p>
          <p className="text-xs text-slate-500 dark:text-slate-400">{plan.planCode}</p>
        </div>
      ),
    },
    {
      key: 'totalAmount',
      header: 'Total Amount',
      render: (plan: ChitPlan) => (
        <div className="flex items-center gap-1.5">
          <IndianRupee className="w-4 h-4 text-slate-400" />
          <span className="font-medium text-slate-800 dark:text-white">
            {plan.totalAmount.toLocaleString()}
          </span>
        </div>
      ),
    },
    {
      key: 'numberOfInstallments',
      header: 'Installments',
      render: (plan: ChitPlan) => (
        <div className="flex items-center gap-1.5">
          <Calendar className="w-4 h-4 text-slate-400" />
          <span className="text-slate-700 dark:text-slate-300">{plan.numberOfInstallments} months</span>
        </div>
      ),
    },
    {
      key: 'monthlyPayment',
      header: 'Monthly Payment',
      render: (plan: ChitPlan) => (
        <div className="flex items-center gap-1.5">
          <IndianRupee className="w-4 h-4 text-accent-500" />
          <span className="font-semibold text-accent-600 dark:text-accent-400">
            {plan.monthlyPayment.toLocaleString()}
          </span>
        </div>
      ),
    },
    {
      key: 'isActive',
      header: 'Status',
      render: (plan: ChitPlan) => (
        <StatusBadge status={plan.isActive ? 'active' : 'paused'} />
      ),
    },
    {
      key: 'actions',
      header: 'Actions',
      render: (plan: ChitPlan) => (
        <div className="flex items-center gap-1">
          <button
            onClick={(e) => {
              e.stopPropagation();
              handleOpenModal(plan);
            }}
            className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-500 hover:text-primary-600 transition-colors"
          >
            <Edit className="w-4 h-4" />
          </button>
          <button
            onClick={(e) => {
              e.stopPropagation();
              handleToggleActive(plan);
            }}
            className={`p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors ${
              plan.isActive
                ? 'text-slate-500 hover:text-red-600'
                : 'text-slate-500 hover:text-accent-600'
            }`}
          >
            <Power className="w-4 h-4" />
          </button>
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-6 animate-fade-in">
      <PageHeader
        title="Chit Plans"
        subtitle="Manage savings schemes"
        action={
          <Button icon={<Plus className="w-4 h-4" />} onClick={() => handleOpenModal()}>
            Create Plan
          </Button>
        }
      />

      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      <Card>
        <div className="mb-4">
          <SearchBar
            value={search}
            onChange={setSearch}
            placeholder="Search plans..."
          />
        </div>

        {isLoading ? (
          <div className="flex justify-center py-16">
            <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : (
          <>
            <Table<ChitPlan>
              columns={columns}
              data={paginatedPlans}
              keyExtractor={(p: ChitPlan) => p.id}
              emptyMessage="No chit plans found"
            />

            <Pagination
              currentPage={currentPage}
              totalPages={Math.max(1, Math.ceil(plans.length / PAGE_SIZE))}
              onPageChange={setCurrentPage}
            />
          </>
        )}
      </Card>

      <Modal
        isOpen={showModal}
        onClose={() => setShowModal(false)}
        title={editingPlan ? 'Edit Chit Plan' : 'Create Chit Plan'}
      >
        <div className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="form-label">Plan Name</label>
              <input
                type="text"
                value={formData.planName}
                onChange={(e) => setFormData({ ...formData, planName: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
                placeholder="e.g., Gold Savings"
              />
            </div>
            <div>
              <label className="form-label">Plan Code</label>
              <input
                type="text"
                value={formData.planCode}
                onChange={(e) => setFormData({ ...formData, planCode: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
                placeholder="e.g., GS-100"
              />
            </div>
          </div>

          <div>
            <label className="form-label">Total Amount</label>
            <input
              type="number"
              value={formData.totalAmount}
              onChange={(e) => setFormData({ ...formData, totalAmount: e.target.value })}
              className="glass-input w-full py-2.5 px-4"
              placeholder="e.g., 100000"
            />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="form-label">Number of Installments</label>
              <input
                type="number"
                value={formData.numberOfInstallments}
                onChange={(e) => setFormData({ ...formData, numberOfInstallments: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
                placeholder="e.g., 20"
              />
            </div>
            <div>
              <label className="form-label">Monthly Payment</label>
              <input
                type="number"
                value={formData.monthlyPayment}
                onChange={(e) => setFormData({ ...formData, monthlyPayment: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
                placeholder="e.g., 5000"
              />
            </div>
          </div>
        </div>

        <div className="flex gap-3 justify-end mt-6">
          <Button variant="secondary" onClick={() => setShowModal(false)}>
            Cancel
          </Button>
          <Button onClick={handleSave} isLoading={isSaving}>
            {editingPlan ? 'Update Plan' : 'Create Plan'}
          </Button>
        </div>
      </Modal>
    </div>
  );
}

```

----------------------------------------

### File: src\pages\admin\CustomerDetailPage.tsx
```tsx
import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { PhotoGallery } from '../../components/ui/PhotoUpload';
import { StatusBadge } from '../../components/ui/Badge';
import { Customer, Subscription } from '../../types';
import {
  deleteCustomer,
  fetchCustomer,
  fetchSubscriptions,
  mapApiError,
} from '../../services/api';
import {
  ArrowLeft,
  Edit,
  Trash2,
  MapPin,
  Phone,
  Mail,
  Calendar,
  CreditCard,
  Navigation,
} from 'lucide-react';
import { Modal } from '../../components/ui/Modal';

export default function CustomerDetailPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [deleteModalOpen, setDeleteModalOpen] = useState(false);
  const [customer, setCustomer] = useState<Customer | null>(null);
  const [subscriptions, setSubscriptions] = useState<Subscription[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isDeleting, setIsDeleting] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    if (!id) return;
    setIsLoading(true);
    Promise.all([
      fetchCustomer(id),
      fetchSubscriptions({ customer: id }),
    ])
      .then(([customerData, subscriptionData]) => {
        setCustomer(customerData);
        setSubscriptions(subscriptionData);
      })
      .catch((err) => setError(mapApiError(err)))
      .finally(() => setIsLoading(false));
  }, [id]);

  const handleDelete = async () => {
    if (!id) return;
    setIsDeleting(true);
    try {
      await deleteCustomer(id);
      navigate('/admin/customers');
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsDeleting(false);
    }
  };

  if (isLoading) {
    return (
      <div className="flex justify-center py-24">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!customer) {
    return (
      <div className="text-center py-12">
        <p className="text-slate-500 dark:text-slate-400">Customer not found</p>
        <Button className="mt-4" onClick={() => navigate('/admin/customers')}>
          Back to Customers
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-6 animate-fade-in max-w-5xl mx-auto">
      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      <PageHeader
        title={customer.name}
        subtitle={`Customer ID: ${customer.customerId}`}
        action={
          <div className="flex gap-2">
            <Button
              variant="ghost"
              onClick={() => navigate(-1)}
              icon={<ArrowLeft className="w-4 h-4" />}
            >
              Back
            </Button>
            <Button
              variant="secondary"
              onClick={() => navigate(`/admin/customers/edit/${customer.id}`)}
              icon={<Edit className="w-4 h-4" />}
            >
              Edit
            </Button>
            <Button
              variant="danger"
              onClick={() => setDeleteModalOpen(true)}
              icon={<Trash2 className="w-4 h-4" />}
            >
              Delete
            </Button>
          </div>
        }
      />

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Main Info */}
        <div className="lg:col-span-2 space-y-6">
          {/* Personal Info */}
          <Card>
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white mb-4">
              Personal Information
            </h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center">
                  <Phone className="w-5 h-5 text-primary-500" />
                </div>
                <div>
                  <p className="text-xs text-slate-500 dark:text-slate-400">Primary Mobile</p>
                  <p className="font-medium text-slate-800 dark:text-white">
                    {customer.primaryMobile}
                  </p>
                </div>
              </div>
              {customer.alternateMobile && (
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-xl bg-slate-100 dark:bg-slate-700 flex items-center justify-center">
                    <Phone className="w-5 h-5 text-slate-500" />
                  </div>
                  <div>
                    <p className="text-xs text-slate-500 dark:text-slate-400">Alternate Mobile</p>
                    <p className="font-medium text-slate-800 dark:text-white">
                      {customer.alternateMobile}
                    </p>
                  </div>
                </div>
              )}
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-accent-50 dark:bg-accent-900/20 flex items-center justify-center">
                  <Mail className="w-5 h-5 text-accent-500" />
                </div>
                <div>
                  <p className="text-xs text-slate-500 dark:text-slate-400">Email</p>
                  <p className="font-medium text-slate-800 dark:text-white">{customer.email}</p>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center">
                  <Calendar className="w-5 h-5 text-blue-500" />
                </div>
                <div>
                  <p className="text-xs text-slate-500 dark:text-slate-400">Created On</p>
                  <p className="font-medium text-slate-800 dark:text-white">
                    {new Date(customer.createdAt).toLocaleDateString()}
                  </p>
                </div>
              </div>
            </div>
          </Card>

          {/* Home Address */}
          <Card>
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <MapPin className="w-5 h-5 text-primary-500" />
                <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
                  Home Address
                </h2>
              </div>
              <a
                href={customer.homeAddress.mapUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-1.5 text-sm text-primary-600 dark:text-primary-400 hover:underline"
              >
                <Navigation className="w-4 h-4" />
                Navigate
              </a>
            </div>
            <div className="grid grid-cols-2 md:grid-cols-3 gap-3 text-sm">
              <div>
                <p className="text-slate-500 dark:text-slate-400">House/Building</p>
                <p className="text-slate-800 dark:text-white">
                  {customer.homeAddress.houseOrBuildingName}
                </p>
              </div>
              <div>
                <p className="text-slate-500 dark:text-slate-400">Landmark</p>
                <p className="text-slate-800 dark:text-white">{customer.homeAddress.landmark}</p>
              </div>
              <div>
                <p className="text-slate-500 dark:text-slate-400">Village</p>
                <p className="text-slate-800 dark:text-white">{customer.homeAddress.village}</p>
              </div>
              <div>
                <p className="text-slate-500 dark:text-slate-400">Taluk</p>
                <p className="text-slate-800 dark:text-white">{customer.homeAddress.taluk}</p>
              </div>
              <div>
                <p className="text-slate-500 dark:text-slate-400">District</p>
                <p className="text-slate-800 dark:text-white">{customer.homeAddress.district}</p>
              </div>
              <div>
                <p className="text-slate-500 dark:text-slate-400">State</p>
                <p className="text-slate-800 dark:text-white">{customer.homeAddress.state}</p>
              </div>
              <div>
                <p className="text-slate-500 dark:text-slate-400">PIN Code</p>
                <p className="text-slate-800 dark:text-white">{customer.homeAddress.pinCode}</p>
              </div>
              {customer.homeAddress.latitude && (
                <div className="col-span-2">
                  <p className="text-slate-500 dark:text-slate-400">Coordinates</p>
                  <p className="text-slate-800 dark:text-white text-xs font-mono">
                    {customer.homeAddress.latitude.toFixed(4)}, {customer.homeAddress.longitude?.toFixed(4)}
                  </p>
                </div>
              )}
            </div>
          </Card>

          {/* Work Address */}
          {customer.workAddress && (
            <Card>
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-2">
                  <MapPin className="w-5 h-5 text-accent-500" />
                  <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
                    Work Address
                  </h2>
                </div>
                <a
                  href={customer.workAddress.mapUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center gap-1.5 text-sm text-primary-600 dark:text-primary-400 hover:underline"
                >
                  <Navigation className="w-4 h-4" />
                  Navigate
                </a>
              </div>
              <div className="grid grid-cols-2 md:grid-cols-3 gap-3 text-sm">
                <div>
                  <p className="text-slate-500 dark:text-slate-400">Office/Building</p>
                  <p className="text-slate-800 dark:text-white">
                    {customer.workAddress.houseOrBuildingName}
                  </p>
                </div>
                <div>
                  <p className="text-slate-500 dark:text-slate-400">Landmark</p>
                  <p className="text-slate-800 dark:text-white">{customer.workAddress.landmark}</p>
                </div>
                <div>
                  <p className="text-slate-500 dark:text-slate-400">Village/Area</p>
                  <p className="text-slate-800 dark:text-white">{customer.workAddress.village}</p>
                </div>
                <div>
                  <p className="text-slate-500 dark:text-slate-400">District</p>
                  <p className="text-slate-800 dark:text-white">{customer.workAddress.district}</p>
                </div>
                <div>
                  <p className="text-slate-500 dark:text-slate-400">PIN Code</p>
                  <p className="text-slate-800 dark:text-white">{customer.workAddress.pinCode}</p>
                </div>
              </div>
            </Card>
          )}

          {/* Photos */}
          <Card>
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white mb-4">
              Uploaded Documents
            </h2>
            <PhotoGallery photos={customer.photos} />
          </Card>
        </div>

        {/* Sidebar */}
        <div className="space-y-6">
          {/* Customer Avatar */}
          <Card className="text-center">
            <img
              src={`https://ui-avatars.com/api/?name=${encodeURIComponent(customer.name)}&background=3b82f6&color=fff&size=128`}
              alt={customer.name}
              className="w-24 h-24 rounded-full mx-auto mb-4"
            />
            <h3 className="text-xl font-bold text-slate-800 dark:text-white">{customer.name}</h3>
            <p className="text-slate-500 dark:text-slate-400">{customer.customerId}</p>
          </Card>

          {/* Subscriptions */}
          <Card>
            <div className="flex items-center gap-2 mb-4">
              <CreditCard className="w-5 h-5 text-primary-500" />
              <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
                Subscriptions
              </h2>
            </div>
            {subscriptions.length === 0 ? (
              <p className="text-sm text-slate-500 dark:text-slate-400">No active subscriptions</p>
            ) : (
              <div className="space-y-3">
                {subscriptions.map((sub) => (
                  <div
                    key={sub.id}
                    className="p-3 rounded-xl bg-slate-50 dark:bg-slate-700/50"
                  >
                    <div className="flex items-center justify-between mb-2">
                      <p className="font-medium text-slate-800 dark:text-white text-sm">
                        {sub.chitPlanName}
                      </p>
                      <StatusBadge status={sub.status} />
                    </div>
                    <div className="flex items-center justify-between text-xs">
                      <span className="text-slate-500 dark:text-slate-400">Payment</span>
                      <StatusBadge status={sub.paymentStatus} />
                    </div>
                    <div className="mt-2 pt-2 border-t border-slate-200 dark:border-slate-600 text-xs">
                      <span className="text-slate-500 dark:text-slate-400">Paid: </span>
                      <span className="text-slate-800 dark:text-white font-medium">
                        ₹{sub.totalPaid.toLocaleString()}
                      </span>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </Card>
        </div>
      </div>

      {/* Delete Modal */}
      <Modal
        isOpen={deleteModalOpen}
        onClose={() => setDeleteModalOpen(false)}
        title="Delete Customer"
        size="sm"
      >
        <p className="text-slate-600 dark:text-slate-300 mb-6">
          Are you sure you want to delete <span className="font-semibold">{customer.name}</span>?
          This will also remove all associated subscriptions and cannot be undone.
        </p>
        <div className="flex gap-3 justify-end">
          <Button variant="secondary" onClick={() => setDeleteModalOpen(false)}>
            Cancel
          </Button>
          <Button variant="danger" onClick={handleDelete} isLoading={isDeleting}>
            Delete
          </Button>
        </div>
      </Modal>
    </div>
  );
}

```

----------------------------------------

### File: src\pages\admin\CustomerFormPage.tsx
```tsx
import { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Card, PageHeader } from '../../components/ui/Card';
import { Input, Button, Select } from '../../components/ui/Form';
import { AddressForm } from '../../components/ui/AddressForm';
import { PhotoUpload } from '../../components/ui/PhotoUpload';
import { ArrowLeft, Save } from 'lucide-react';
import {
  createCustomerWithDetails,
  fetchChitPlans,
  fetchCustomer,
  mapApiError,
  updateCustomer,
} from '../../services/api';
import { ChitPlan } from '../../types';

export default function CustomerFormPage() {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;

  const [isLoading, setIsLoading] = useState(isEdit);
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState('');
  const [chitPlans, setChitPlans] = useState<ChitPlan[]>([]);
  const [generatedId, setGeneratedId] = useState('Auto-generated');

  const [customer, setCustomer] = useState({
    name: '',
    primaryMobile: '',
    alternateMobile: '',
    email: '',
  });

  const [homeAddress, setHomeAddress] = useState({
    id: '',
    type: 'home' as const,
    houseOrBuildingName: '',
    landmark: '',
    village: '',
    taluk: '',
    district: '',
    state: '',
    pinCode: '',
    latitude: null as number | null,
    longitude: null as number | null,
    mapUrl: '',
  });

  const [workAddress, setWorkAddress] = useState({
    id: '',
    type: 'work' as const,
    houseOrBuildingName: '',
    landmark: '',
    village: '',
    taluk: '',
    district: '',
    state: '',
    pinCode: '',
    latitude: null as number | null,
    longitude: null as number | null,
    mapUrl: '',
  });

  const [photos, setPhotos] = useState({
    customer: '',
    addressProof: '',
    idProof: '',
    workLocation: '',
  });

  const [subscription, setSubscription] = useState({
    chitPlanId: '',
    joinedDate: new Date().toISOString().split('T')[0],
  });

  const [addWorkAddress, setAddWorkAddress] = useState(false);
  const [enrollInPlan, setEnrollInPlan] = useState(false);

  useEffect(() => {
    fetchChitPlans()
      .then((plans) => setChitPlans(plans.filter((p) => p.isActive)))
      .catch(() => {});
  }, []);

  useEffect(() => {
    if (!isEdit || !id) return;

    setIsLoading(true);
    fetchCustomer(id)
      .then((data) => {
        setGeneratedId(data.customerId);
        setCustomer({
          name: data.name,
          primaryMobile: data.primaryMobile,
          alternateMobile: data.alternateMobile || '',
          email: data.email,
        });
        setHomeAddress({ ...data.homeAddress, type: 'home' });
        if (data.workAddress) {
          setWorkAddress({ ...data.workAddress, type: 'work' });
          setAddWorkAddress(true);
        }
      })
      .catch((err) => setError(mapApiError(err)))
      .finally(() => setIsLoading(false));
  }, [id, isEdit]);

  const handleSave = async () => {
    setError('');
    setIsSaving(true);
    try {
      if (isEdit && id) {
        await updateCustomer(id, customer);
      } else {
        await createCustomerWithDetails({
          customer,
          homeAddress,
          workAddress: addWorkAddress ? workAddress : null,
          photos,
          subscription: enrollInPlan ? subscription : null,
        });
      }
      navigate('/admin/customers');
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsSaving(false);
    }
  };

  if (isLoading) {
    return (
      <div className="flex justify-center py-24">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-6 animate-fade-in max-w-4xl mx-auto">
      <PageHeader
        title={isEdit ? 'Edit Customer' : 'Add Customer'}
        subtitle={isEdit ? 'Update customer information' : 'Onboard a new customer'}
        action={
          <Button variant="ghost" onClick={() => navigate(-1)} icon={<ArrowLeft className="w-4 h-4" />}>
            Back
          </Button>
        }
      />

      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      <Card>
        <h2 className="text-lg font-semibold text-slate-800 dark:text-white mb-4">
          Personal Information
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Input
            label="Customer Name"
            placeholder="Full name as per ID proof"
            value={customer.name}
            onChange={(e) => setCustomer({ ...customer, name: e.target.value })}
            required
          />
          <Input
            label="Customer ID"
            placeholder="Auto-generated"
            value={generatedId}
            disabled
            className="opacity-60"
          />
          <Input
            label="Primary Mobile Number"
            placeholder="+91 XXXXX XXXXX"
            value={customer.primaryMobile}
            onChange={(e) => setCustomer({ ...customer, primaryMobile: e.target.value })}
            required
          />
          <Input
            label="Alternate Mobile Number"
            placeholder="+91 XXXXX XXXXX (optional)"
            value={customer.alternateMobile}
            onChange={(e) => setCustomer({ ...customer, alternateMobile: e.target.value })}
          />
          <Input
            label="Email Address"
            type="email"
            placeholder="customer@email.com"
            value={customer.email}
            onChange={(e) => setCustomer({ ...customer, email: e.target.value })}
            className="md:col-span-2"
          />
        </div>
      </Card>

      {!isEdit && (
        <>
          <Card>
            <AddressForm
              type="home"
              data={homeAddress}
              onChange={(data) => setHomeAddress({ ...homeAddress, ...data })}
            />
          </Card>

          <Card>
            <label className="flex items-center gap-3 cursor-pointer">
              <input
                type="checkbox"
                checked={addWorkAddress}
                onChange={(e) => setAddWorkAddress(e.target.checked)}
                className="w-5 h-5 rounded border-slate-300 text-primary-600 focus:ring-primary-500"
              />
              <div>
                <p className="font-medium text-slate-800 dark:text-white">Add Work Address</p>
                <p className="text-sm text-slate-500 dark:text-slate-400">
                  Include customer's workplace location
                </p>
              </div>
            </label>
          </Card>

          {addWorkAddress && (
            <Card>
              <AddressForm
                type="work"
                data={workAddress}
                onChange={(data) => setWorkAddress({ ...workAddress, ...data })}
              />
            </Card>
          )}

          <Card>
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white mb-4">
              Photo Uploads
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <PhotoUpload
                type="customer"
                label="Customer Photo"
                value={photos.customer}
                onChange={(url) => setPhotos({ ...photos, customer: url })}
              />
              <PhotoUpload
                type="address_proof"
                label="Address Proof"
                value={photos.addressProof}
                onChange={(url) => setPhotos({ ...photos, addressProof: url })}
              />
              <PhotoUpload
                type="id_proof"
                label="ID Proof"
                value={photos.idProof}
                onChange={(url) => setPhotos({ ...photos, idProof: url })}
              />
              {addWorkAddress && (
                <PhotoUpload
                  type="work_location"
                  label="Work Location Photo"
                  value={photos.workLocation}
                  onChange={(url) => setPhotos({ ...photos, workLocation: url })}
                />
              )}
            </div>
          </Card>

          <Card>
            <label className="flex items-center gap-3 cursor-pointer mb-4">
              <input
                type="checkbox"
                checked={enrollInPlan}
                onChange={(e) => setEnrollInPlan(e.target.checked)}
                className="w-5 h-5 rounded border-slate-300 text-primary-600 focus:ring-primary-500"
              />
              <div>
                <p className="font-medium text-slate-800 dark:text-white">Enroll in Chit Plan</p>
                <p className="text-sm text-slate-500 dark:text-slate-400">
                  Subscribe customer to a chit plan immediately
                </p>
              </div>
            </label>

            {enrollInPlan && (
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4 pt-4 border-t border-slate-200/50 dark:border-slate-700/50">
                <Select
                  label="Select Chit Plan"
                  value={subscription.chitPlanId}
                  onChange={(e) => setSubscription({ ...subscription, chitPlanId: e.target.value })}
                  options={[
                    { value: '', label: 'Choose a plan...' },
                    ...chitPlans.map((p) => ({
                      value: p.id,
                      label: `${p.planName} - ₹${p.monthlyPayment}/month`,
                    })),
                  ]}
                />
                <Input
                  label="Joined Date"
                  type="date"
                  value={subscription.joinedDate}
                  onChange={(e) => setSubscription({ ...subscription, joinedDate: e.target.value })}
                />
              </div>
            )}
          </Card>
        </>
      )}

      <div className="flex justify-end gap-3">
        <Button variant="secondary" onClick={() => navigate('/admin/customers')}>
          Cancel
        </Button>
        <Button icon={<Save className="w-4 h-4" />} onClick={handleSave} isLoading={isSaving}>
          {isEdit ? 'Update Customer' : 'Save Customer'}
        </Button>
      </div>
    </div>
  );
}

```

----------------------------------------

### File: src\pages\admin\CustomersPage.tsx
```tsx
import { useCallback, useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Table, Pagination, SearchBar } from '../../components/ui/Table';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { Customer } from '../../types';
import { Plus, Eye, Edit, Trash2, MapPin, Phone, Mail } from 'lucide-react';
import { Modal } from '../../components/ui/Modal';
import { deleteCustomer, fetchCustomers, mapApiError } from '../../services/api';

const PAGE_SIZE = 10;

export default function CustomersPage() {
  const navigate = useNavigate();
  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');
  const [deleteModal, setDeleteModal] = useState<{ open: boolean; customer: Customer | null }>({
    open: false,
    customer: null,
  });
  const [isDeleting, setIsDeleting] = useState(false);

  const loadCustomers = useCallback(async () => {
    setIsLoading(true);
    setError('');
    try {
      const data = await fetchCustomers(search ? { search } : {});
      setCustomers(data);
      setCurrentPage(1);
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsLoading(false);
    }
  }, [search]);

  useEffect(() => {
    const timer = setTimeout(() => {
      loadCustomers();
    }, 300);
    return () => clearTimeout(timer);
  }, [loadCustomers]);

  const paginatedCustomers = customers.slice(
    (currentPage - 1) * PAGE_SIZE,
    currentPage * PAGE_SIZE,
  );

  const handleDelete = async () => {
    if (!deleteModal.customer) return;
    setIsDeleting(true);
    try {
      await deleteCustomer(deleteModal.customer.id);
      setDeleteModal({ open: false, customer: null });
      await loadCustomers();
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsDeleting(false);
    }
  };

  const columns = [
    {
      key: 'name',
      header: 'Customer',
      render: (customer: Customer) => (
        <div className="flex items-center gap-3">
          <img
            src={`https://ui-avatars.com/api/?name=${encodeURIComponent(customer.name)}&background=3b82f6&color=fff`}
            alt={customer.name}
            className="w-10 h-10 rounded-full"
          />
          <div>
            <p className="font-medium text-slate-800 dark:text-white">{customer.name}</p>
            <p className="text-xs text-slate-500 dark:text-slate-400">{customer.customerId}</p>
          </div>
        </div>
      ),
    },
    {
      key: 'primaryMobile',
      header: 'Contact',
      render: (customer: Customer) => (
        <div className="space-y-1">
          <div className="flex items-center gap-1.5 text-sm text-slate-600 dark:text-slate-300">
            <Phone className="w-3.5 h-3.5" />
            {customer.primaryMobile}
          </div>
          {customer.alternateMobile && (
            <div className="flex items-center gap-1.5 text-xs text-slate-400">
              <Phone className="w-3 h-3" />
              {customer.alternateMobile}
            </div>
          )}
        </div>
      ),
    },
    {
      key: 'email',
      header: 'Email',
      render: (customer: Customer) => (
        <div className="flex items-center gap-1.5 text-sm text-slate-600 dark:text-slate-300">
          <Mail className="w-4 h-4" />
          {customer.email || '—'}
        </div>
      ),
    },
    {
      key: 'address',
      header: 'Location',
      render: (customer: Customer) => (
        <div className="flex items-center gap-1.5 text-sm text-slate-600 dark:text-slate-300">
          <MapPin className="w-4 h-4" />
          {customer.homeAddress.district
            ? `${customer.homeAddress.district}, ${customer.homeAddress.state}`
            : '—'}
        </div>
      ),
    },
    {
      key: 'actions',
      header: 'Actions',
      render: (customer: Customer) => (
        <div className="flex items-center gap-1">
          <button
            onClick={(e) => {
              e.stopPropagation();
              navigate(`/admin/customers/${customer.id}`);
            }}
            className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-500 hover:text-primary-600 transition-colors"
          >
            <Eye className="w-4 h-4" />
          </button>
          <button
            onClick={(e) => {
              e.stopPropagation();
              navigate(`/admin/customers/edit/${customer.id}`);
            }}
            className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-500 hover:text-accent-600 transition-colors"
          >
            <Edit className="w-4 h-4" />
          </button>
          <button
            onClick={(e) => {
              e.stopPropagation();
              setDeleteModal({ open: true, customer });
            }}
            className="p-2 rounded-lg hover:bg-red-50 dark:hover:bg-red-900/20 text-slate-500 hover:text-red-600 transition-colors"
          >
            <Trash2 className="w-4 h-4" />
          </button>
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-6 animate-fade-in">
      <PageHeader
        title="Customers"
        subtitle="Manage all customer records"
        action={
          <Link to="/admin/customers/add">
            <Button icon={<Plus className="w-4 h-4" />}>Add Customer</Button>
          </Link>
        }
      />

      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      <Card>
        <div className="flex flex-col sm:flex-row gap-4 mb-4">
          <SearchBar
            value={search}
            onChange={setSearch}
            placeholder="Search by name, ID, or phone..."
          />
        </div>

        {isLoading ? (
          <div className="flex justify-center py-16">
            <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : (
          <>
            <Table
              columns={columns}
              data={paginatedCustomers}
              keyExtractor={(c) => c.id}
              onRowClick={(c) => navigate(`/admin/customers/${c.id}`)}
              emptyMessage="No customers found"
            />

            <Pagination
              currentPage={currentPage}
              totalPages={Math.max(1, Math.ceil(customers.length / PAGE_SIZE))}
              onPageChange={setCurrentPage}
            />
          </>
        )}
      </Card>

      <Modal
        isOpen={deleteModal.open}
        onClose={() => setDeleteModal({ open: false, customer: null })}
        title="Delete Customer"
        size="sm"
      >
        <p className="text-slate-600 dark:text-slate-300 mb-6">
          Are you sure you want to delete{' '}
          <span className="font-semibold">{deleteModal.customer?.name}</span>? This action
          cannot be undone.
        </p>
        <div className="flex gap-3 justify-end">
          <Button
            variant="secondary"
            onClick={() => setDeleteModal({ open: false, customer: null })}
          >
            Cancel
          </Button>
          <Button variant="danger" onClick={handleDelete} isLoading={isDeleting}>
            Delete
          </Button>
        </div>
      </Modal>
    </div>
  );
}

```

----------------------------------------

### File: src\pages\admin\Dashboard.tsx
```tsx
import { useCallback, useEffect, useState } from 'react';
import { StatCard, Card, PageHeader } from '../../components/ui/Card';
import {
  Users,
  CreditCard,
  IndianRupee,
  Clock,
  FileText,
  UserPlus,
  TrendingUp,
  ArrowRight,
} from 'lucide-react';
import { Link } from 'react-router-dom';
import {
  fetchDashboardRecentCustomers,
  fetchDashboardRecentSubscriptions,
  fetchDashboardStats,
  mapApiError,
} from '../../services/api';
import type {
  DashboardRecentCustomer,
  DashboardRecentSubscription,
  DashboardStats,
} from '../../types';

function formatMonthlyCollection(amount: number): string {
  if (amount >= 100000) {
    return `₹${(amount / 100000).toFixed(1)}L`;
  }
  if (amount >= 1000) {
    return `₹${(amount / 1000).toFixed(1)}K`;
  }
  return `₹${amount.toLocaleString()}`;
}

function SectionSpinner() {
  return (
    <div className="flex items-center justify-center py-8">
      <div className="w-6 h-6 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
    </div>
  );
}

export default function Dashboard() {
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [recentCustomers, setRecentCustomers] = useState<DashboardRecentCustomer[]>([]);
  const [recentSubscriptions, setRecentSubscriptions] = useState<DashboardRecentSubscription[]>([]);
  const [isLoadingStats, setIsLoadingStats] = useState(true);
  const [isLoadingCustomers, setIsLoadingCustomers] = useState(true);
  const [isLoadingSubscriptions, setIsLoadingSubscriptions] = useState(true);
  const [statsError, setStatsError] = useState('');
  const [customersError, setCustomersError] = useState('');
  const [subscriptionsError, setSubscriptionsError] = useState('');

  const loadStats = useCallback(async () => {
    setIsLoadingStats(true);
    setStatsError('');
    try {
      const statsData = await fetchDashboardStats();
      setStats(statsData);
    } catch (err) {
      setStatsError(mapApiError(err));
    } finally {
      setIsLoadingStats(false);
    }
  }, []);

  const loadRecentCustomers = useCallback(async () => {
    setIsLoadingCustomers(true);
    setCustomersError('');
    try {
      const data = await fetchDashboardRecentCustomers();
      setRecentCustomers(data);
    } catch (err) {
      setCustomersError(mapApiError(err));
    } finally {
      setIsLoadingCustomers(false);
    }
  }, []);

  const loadRecentSubscriptions = useCallback(async () => {
    setIsLoadingSubscriptions(true);
    setSubscriptionsError('');
    try {
      const data = await fetchDashboardRecentSubscriptions();
      setRecentSubscriptions(data);
    } catch (err) {
      setSubscriptionsError(mapApiError(err));
    } finally {
      setIsLoadingSubscriptions(false);
    }
  }, []);

  useEffect(() => {
    loadStats();
    loadRecentCustomers();
    loadRecentSubscriptions();
  }, [loadStats, loadRecentCustomers, loadRecentSubscriptions]);

  return (
    <div className="space-y-6 animate-fade-in">
      <PageHeader
        title="Dashboard"
        subtitle="Welcome back! Here's your overview."
      />

      {/* Stats Grid */}
      {isLoadingStats ? (
        <div className="flex items-center justify-center py-16">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : (
        <>
          {statsError && (
            <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
              {statsError}
            </div>
          )}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4">
            <div className="sm:col-span-2 lg:col-span-1 xl:col-span-2">
              <StatCard
                title="Total Customers"
                value={stats ? stats.totalCustomers.toLocaleString() : '—'}
                subtitle="All time"
                icon={<Users className="w-6 h-6" />}
                color="primary"
              />
            </div>
            <StatCard
              title="Active Chitties"
              value={stats ? stats.activeChitties.toLocaleString() : '—'}
              subtitle="Currently running"
              icon={<CreditCard className="w-6 h-6" />}
              color="accent"
            />
            <StatCard
              title="Monthly Collection"
              value={stats ? formatMonthlyCollection(stats.monthlyCollections) : '—'}
              subtitle="Expected this month"
              icon={<IndianRupee className="w-6 h-6" />}
              color="primary"
            />
            <StatCard
              title="Pending Payments"
              value={stats ? stats.pendingPayments.toLocaleString() : '—'}
              subtitle="Requires attention"
              icon={<Clock className="w-6 h-6" />}
              color="warning"
            />
            <StatCard
              title="Active Plans"
              value={stats ? stats.activePlans.toLocaleString() : '—'}
              subtitle="Chit plans available"
              icon={<FileText className="w-6 h-6" />}
              color="accent"
            />
            <StatCard
              title="Recent Onboardings"
              value={stats ? stats.recentOnboardings.toLocaleString() : '—'}
              subtitle="Last 7 days"
              icon={<UserPlus className="w-6 h-6" />}
              color="primary"
            />
          </div>
        </>
      )}

      {/* Quick Actions */}
      <Card>
        <h2 className="text-lg font-semibold text-slate-800 dark:text-white mb-4">
          Quick Actions
        </h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          <Link
            to="/admin/customers/add"
            className="flex items-center gap-3 p-4 rounded-xl bg-gradient-to-br from-primary-50 to-primary-100/50 dark:from-primary-900/20 dark:to-primary-900/10 hover:from-primary-100 hover:to-primary-200/50 dark:hover:from-primary-900/30 dark:hover:to-primary-900/20 transition-all group"
          >
            <div className="w-10 h-10 rounded-xl bg-primary-500 flex items-center justify-center text-white group-hover:scale-110 transition-transform">
              <UserPlus className="w-5 h-5" />
            </div>
            <div>
              <p className="font-medium text-slate-800 dark:text-white">Add Customer</p>
              <p className="text-xs text-slate-500 dark:text-slate-400">New onboarding</p>
            </div>
          </Link>
          <Link
            to="/admin/employees/add"
            className="flex items-center gap-3 p-4 rounded-xl bg-gradient-to-br from-accent-50 to-accent-100/50 dark:from-accent-900/20 dark:to-accent-900/10 hover:from-accent-100 hover:to-accent-200/50 dark:hover:from-accent-900/30 dark:hover:to-accent-900/20 transition-all group"
          >
            <div className="w-10 h-10 rounded-xl bg-accent-500 flex items-center justify-center text-white group-hover:scale-110 transition-transform">
              <Users className="w-5 h-5" />
            </div>
            <div>
              <p className="font-medium text-slate-800 dark:text-white">Add Employee</p>
              <p className="text-xs text-slate-500 dark:text-slate-400">Field agent</p>
            </div>
          </Link>
          <Link
            to="/admin/plans/add"
            className="flex items-center gap-3 p-4 rounded-xl bg-gradient-to-br from-blue-50 to-blue-100/50 dark:from-blue-900/20 dark:to-blue-900/10 hover:from-blue-100 hover:to-blue-200/50 dark:hover:from-blue-900/30 dark:hover:to-blue-900/20 transition-all group"
          >
            <div className="w-10 h-10 rounded-xl bg-blue-500 flex items-center justify-center text-white group-hover:scale-110 transition-transform">
              <FileText className="w-5 h-5" />
            </div>
            <div>
              <p className="font-medium text-slate-800 dark:text-white">Create Plan</p>
              <p className="text-xs text-slate-500 dark:text-slate-400">Chit scheme</p>
            </div>
          </Link>
          <Link
            to="/admin/reports"
            className="flex items-center gap-3 p-4 rounded-xl bg-gradient-to-br from-purple-50 to-purple-100/50 dark:from-purple-900/20 dark:to-purple-900/10 hover:from-purple-100 hover:to-purple-200/50 dark:hover:from-purple-900/30 dark:hover:to-purple-900/20 transition-all group"
          >
            <div className="w-10 h-10 rounded-xl bg-purple-500 flex items-center justify-center text-white group-hover:scale-110 transition-transform">
              <TrendingUp className="w-5 h-5" />
            </div>
            <div>
              <p className="font-medium text-slate-800 dark:text-white">View Reports</p>
              <p className="text-xs text-slate-500 dark:text-slate-400">Analytics</p>
            </div>
          </Link>
        </div>
      </Card>

      {/* Recent sections */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Recent Customers */}
        <Card>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
              Recent Customers
            </h2>
            <Link
              to="/admin/customers"
              className="flex items-center gap-1 text-sm text-primary-600 dark:text-primary-400 hover:underline"
            >
              View all <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
          {customersError && (
            <div className="mb-3 p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
              {customersError}
            </div>
          )}
          {isLoadingCustomers ? (
            <SectionSpinner />
          ) : recentCustomers.length === 0 ? (
            <p className="text-sm text-slate-500 dark:text-slate-400 py-4 text-center">
              No customers yet
            </p>
          ) : (
            <div className="space-y-3">
              {recentCustomers.map((customer) => (
                <Link
                  key={customer.id}
                  to={`/admin/customers/${customer.id}`}
                  className="flex items-center gap-4 p-3 rounded-xl hover:bg-slate-50 dark:hover:bg-slate-700/50 transition-colors"
                >
                  <img
                    src={`https://ui-avatars.com/api/?name=${encodeURIComponent(customer.name)}&background=3b82f6&color=fff`}
                    alt={customer.name}
                    className="w-10 h-10 rounded-full"
                  />
                  <div className="flex-1 min-w-0">
                    <p className="font-medium text-slate-800 dark:text-white truncate">
                      {customer.name}
                    </p>
                    <p className="text-sm text-slate-500 dark:text-slate-400">{customer.customerId}</p>
                  </div>
                  <span className="text-sm text-slate-400 dark:text-slate-500">
                    {new Date(customer.createdAt).toLocaleDateString()}
                  </span>
                </Link>
              ))}
            </div>
          )}
        </Card>

        {/* Active Subscriptions */}
        <Card>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
              Active Subscriptions
            </h2>
            <Link
              to="/admin/subscriptions"
              className="flex items-center gap-1 text-sm text-primary-600 dark:text-primary-400 hover:underline"
            >
              View all <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
          {subscriptionsError && (
            <div className="mb-3 p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
              {subscriptionsError}
            </div>
          )}
          {isLoadingSubscriptions ? (
            <SectionSpinner />
          ) : recentSubscriptions.length === 0 ? (
            <p className="text-sm text-slate-500 dark:text-slate-400 py-4 text-center">
              No active subscriptions
            </p>
          ) : (
            <div className="space-y-3">
              {recentSubscriptions.map((sub) => (
                <div
                  key={sub.id}
                  className="flex items-center gap-4 p-3 rounded-xl hover:bg-slate-50 dark:hover:bg-slate-700/50 transition-colors"
                >
                  <div className="w-10 h-10 rounded-full bg-gradient-to-br from-primary-400 to-primary-500 flex items-center justify-center text-white font-semibold">
                    {sub.customerName.charAt(0)}
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="font-medium text-slate-800 dark:text-white truncate">
                      {sub.customerName}
                    </p>
                    <p className="text-sm text-slate-500 dark:text-slate-400">
                      {sub.chitPlanName}
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-medium text-slate-800 dark:text-white">
                      ₹{sub.monthlyPayment.toLocaleString()}
                    </p>
                    <p className="text-xs text-slate-500 dark:text-slate-400 capitalize">
                      {sub.paymentStatus}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          )}
        </Card>
      </div>
    </div>
  );
}

```

----------------------------------------

### File: src\pages\admin\EmployeesPage.tsx
```tsx
import { useState } from 'react';
import { Table, Pagination, SearchBar } from '../../components/ui/Table';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { StatusBadge, Badge } from '../../components/ui/Badge';
import { Modal } from '../../components/ui/Modal';
import { mockEmployees } from '../../data/mockData';
import { Employee } from '../../types';
import { Plus, Edit, Power, Mail, Phone, Users, Shield } from 'lucide-react';

export default function EmployeesPage() {
  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [showModal, setShowModal] = useState(false);
  const [editingEmployee, setEditingEmployee] = useState<Employee | null>(null);
  const [formData, setFormData] = useState({
    name: '',
    username: '',
    email: '',
    phone: '',
    role: 'agent' as 'admin' | 'agent',
    password: '',
  });

  const filteredEmployees = mockEmployees.filter(
    (e) =>
      e.name.toLowerCase().includes(search.toLowerCase()) ||
      e.username.toLowerCase().includes(search.toLowerCase()) ||
      e.email.toLowerCase().includes(search.toLowerCase())
  );

  const handleOpenModal = (employee?: Employee) => {
    if (employee) {
      setEditingEmployee(employee);
      setFormData({
        name: employee.name,
        username: employee.username,
        email: employee.email,
        phone: employee.phone,
        role: employee.role,
        password: '',
      });
    } else {
      setEditingEmployee(null);
      setFormData({
        name: '',
        username: '',
        email: '',
        phone: '',
        role: 'agent',
        password: '',
      });
    }
    setShowModal(true);
  };

  const columns = [
    {
      key: 'name',
      header: 'Employee',
      render: (emp: Employee) => (
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-gradient-to-br from-primary-400 to-primary-500 flex items-center justify-center text-white font-semibold">
            {emp.name.charAt(0)}
          </div>
          <div>
            <p className="font-medium text-slate-800 dark:text-white">{emp.name}</p>
            <p className="text-xs text-slate-500 dark:text-slate-400">{emp.employeeId}</p>
          </div>
        </div>
      ),
    },
    {
      key: 'username',
      header: 'Username',
      render: (emp: Employee) => (
        <span className="text-sm font-mono text-slate-600 dark:text-slate-300">@{emp.username}</span>
      ),
    },
    {
      key: 'contact',
      header: 'Contact',
      render: (emp: Employee) => (
        <div className="space-y-1">
          <div className="flex items-center gap-1.5 text-sm text-slate-600 dark:text-slate-300">
            <Mail className="w-3.5 h-3.5" />
            {emp.email}
          </div>
          <div className="flex items-center gap-1.5 text-xs text-slate-400">
            <Phone className="w-3 h-3" />
            {emp.phone}
          </div>
        </div>
      ),
    },
    {
      key: 'role',
      header: 'Role',
      render: (emp: Employee) => (
        <Badge variant={emp.role === 'admin' ? 'info' : 'default'}>
          {emp.role === 'admin' ? (
            <span className="flex items-center gap-1">
              <Shield className="w-3 h-3" /> Admin
            </span>
          ) : (
            <span className="flex items-center gap-1">
              <Users className="w-3 h-3" /> Agent
            </span>
          )}
        </Badge>
      ),
    },
    {
      key: 'customersCount',
      header: 'Customers',
      render: (emp: Employee) => (
        <span className="font-medium text-slate-800 dark:text-white">{emp.customersCount}</span>
      ),
    },
    {
      key: 'isActive',
      header: 'Status',
      render: (emp: Employee) => (
        <StatusBadge status={emp.isActive ? 'active' : 'paused'} />
      ),
    },
    {
      key: 'actions',
      header: 'Actions',
      render: (emp: Employee) => (
        <div className="flex items-center gap-1">
          <button
            onClick={(e) => {
              e.stopPropagation();
              handleOpenModal(emp);
            }}
            className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-500 hover:text-primary-600 transition-colors"
          >
            <Edit className="w-4 h-4" />
          </button>
          <button
            onClick={(e) => {
              e.stopPropagation();
              // Toggle active status
            }}
            className={`p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors ${
              emp.isActive
                ? 'text-slate-500 hover:text-red-600'
                : 'text-slate-500 hover:text-accent-600'
            }`}
          >
            <Power className="w-4 h-4" />
          </button>
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-6 animate-fade-in">
      <PageHeader
        title="Employees"
        subtitle="Manage team members"
        action={
          <Button icon={<Plus className="w-4 h-4" />} onClick={() => handleOpenModal()}>
            Add Employee
          </Button>
        }
      />

      <Card>
        <div className="flex flex-col sm:flex-row gap-4 mb-4">
          <SearchBar value={search} onChange={setSearch} placeholder="Search employees..." />
          <select className="glass-input py-2.5 px-4 text-sm">
            <option>All Roles</option>
            <option>Admin</option>
            <option>Agent</option>
          </select>
          <select className="glass-input py-2.5 px-4 text-sm">
            <option>All Status</option>
            <option>Active</option>
            <option>Inactive</option>
          </select>
        </div>

        <Table
          columns={columns}
          data={filteredEmployees}
          keyExtractor={(e) => e.id}
          emptyMessage="No employees found"
        />

        <Pagination
          currentPage={currentPage}
          totalPages={Math.ceil(filteredEmployees.length / 10)}
          onPageChange={setCurrentPage}
        />
      </Card>

      {/* Add/Edit Modal */}
      <Modal
        isOpen={showModal}
        onClose={() => setShowModal(false)}
        title={editingEmployee ? 'Edit Employee' : 'Add Employee'}
      >
        <div className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="form-label">Full Name</label>
              <input
                type="text"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
                placeholder="Enter full name"
              />
            </div>
            <div>
              <label className="form-label">Username</label>
              <input
                type="text"
                value={formData.username}
                onChange={(e) => setFormData({ ...formData, username: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
                placeholder="Enter username"
              />
            </div>
          </div>

          <div>
            <label className="form-label">Email Address</label>
            <input
              type="email"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              className="glass-input w-full py-2.5 px-4"
              placeholder="employee@chittyfinance.com"
            />
          </div>

          <div>
            <label className="form-label">Phone Number</label>
            <input
              type="tel"
              value={formData.phone}
              onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
              className="glass-input w-full py-2.5 px-4"
              placeholder="+91 XXXXX XXXXX"
            />
          </div>

          <div>
            <label className="form-label">Role</label>
            <div className="flex gap-4 mt-2">
              <label className="flex items-center gap-2 cursor-pointer">
                <input
                  type="radio"
                  name="role"
                  checked={formData.role === 'admin'}
                  onChange={() => setFormData({ ...formData, role: 'admin' })}
                  className="w-4 h-4 text-primary-600"
                />
                <span className="text-sm text-slate-700 dark:text-slate-300">Admin</span>
              </label>
              <label className="flex items-center gap-2 cursor-pointer">
                <input
                  type="radio"
                  name="role"
                  checked={formData.role === 'agent'}
                  onChange={() => setFormData({ ...formData, role: 'agent' })}
                  className="w-4 h-4 text-primary-600"
                />
                <span className="text-sm text-slate-700 dark:text-slate-300">Field Agent</span>
              </label>
            </div>
          </div>

          {!editingEmployee && (
            <div>
              <label className="form-label">Password</label>
              <input
                type="password"
                value={formData.password}
                onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
                placeholder="Set password"
              />
            </div>
          )}
        </div>

        <div className="flex gap-3 justify-end mt-6">
          <Button variant="secondary" onClick={() => setShowModal(false)}>
            Cancel
          </Button>
          <Button onClick={() => setShowModal(false)}>
            {editingEmployee ? 'Update Employee' : 'Add Employee'}
          </Button>
        </div>
      </Modal>
    </div>
  );
}

```

----------------------------------------

### File: src\pages\admin\ReportsPage.tsx
```tsx
import { Card, PageHeader, StatCard } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { useEffect, useState } from 'react';
import api from '../../services/api';
import {
  Download,
  TrendingUp,
  Users,
  IndianRupee,
  Calendar,
  BarChart3,
  PieChart,
} from 'lucide-react';

export default function ReportsPage() {
  const [summary, setSummary] = useState<any>(null);
  const [monthlyData, setMonthlyData] = useState<any[]>([]);
  const [planData, setPlanData] = useState<any[]>([]);
  const [paymentData, setPaymentData] = useState<any>(null);
  const [, setLoading] = useState(true);

  useEffect(() => {
    fetchReports();
  }, []);

  const fetchReports = async () => {
    try {

      const summaryRes = await api.get('/reports/summary/');
      setSummary(summaryRes.data);

      const monthlyRes = await api.get('/reports/monthly-collections/');
      setMonthlyData(monthlyRes.data);

      const planRes = await api.get('/reports/plan-distribution/');
      setPlanData(planRes.data);

      const paymentRes = await api.get('/reports/payment-overview/');
      setPaymentData(paymentRes.data);

    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6 animate-fade-in">
      <PageHeader
        title="Reports & Analytics"
        subtitle="View detailed business insights"
        action={
          <Button variant="secondary" icon={<Download className="w-4 h-4" />}>
            Export Report
          </Button>
        }
      />

      {/* Time Period Selector */}
      <Card>
        <div className="flex flex-wrap gap-2">
          <button className="px-4 py-2 rounded-lg bg-primary-50 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400 font-medium text-sm">
            This Month
          </button>
          <button className="px-4 py-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300 font-medium text-sm transition-colors">
            Last Month
          </button>
          <button className="px-4 py-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300 font-medium text-sm transition-colors">
            Last 3 Months
          </button>
          <button className="px-4 py-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300 font-medium text-sm transition-colors">
            This Year
          </button>
          <button className="px-4 py-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300 font-medium text-sm transition-colors">
            Custom Range
          </button>
        </div>
      </Card>

      {/* Summary Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          title="Total Collections"
          value={`₹${summary?.total_collections || 0}`}
          icon={<IndianRupee className="w-6 h-6" />}
          trend={{ value: 18.5, isPositive: true }}
          color="primary"
        />
        <StatCard
          title="New Customers"
          value={summary?.new_customers || 0}
          icon={<Users className="w-6 h-6" />}
          trend={{ value: 12, isPositive: true }}
          color="accent"
        />
        <StatCard
          title="Active Chitties"
          value={summary?.active_chitties || 0}
          icon={<TrendingUp className="w-6 h-6" />}
          trend={{ value: 5, isPositive: true }}
          color="primary"
        />
        <StatCard
          title="Pending Payments"
          value={summary?.pending_payments || 0}
          icon={<Calendar className="w-6 h-6" />}
          trend={{ value: 2, isPositive: false }}
          color="warning"
        />
      </div>

      {/* Charts Placeholder */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <div className="flex items-center gap-3 mb-6">
            <div className="w-10 h-10 rounded-xl bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center">
              <BarChart3 className="w-5 h-5 text-primary-500" />
            </div>
            <div>
              <h2 className="text-lg font-semibold text-slate-800 dark:text-white">
                Monthly Collections
              </h2>
              <p className="text-sm text-slate-500 dark:text-slate-400">Last 6 months trend</p>
            </div>
          </div>
          <div className="h-64 flex items-end justify-around gap-4 px-4">
            {monthlyData.map((item, i) => (
              <div key={i} className="flex flex-col items-center gap-2 flex-1">
                <div
      className="w-full rounded-t-lg bg-gradient-to-t from-primary-400 to-primary-500 transition-all hover:from-primary-500 hover:to-primary-600"
      style={{
        height: `${Math.min(item.amount / 500, 100)}%`,
      }}
    />

    <span className="text-xs text-slate-500">
      {item.month}
    </span>
  </div>
))}
          </div>
        </Card>

        <Card>
          <div className="flex items-center gap-3 mb-6">
            <div className="w-10 h-10 rounded-xl bg-accent-50 dark:bg-accent-900/20 flex items-center justify-center">
              <PieChart className="w-5 h-5 text-accent-500" />
            </div>
            <div>
              <h2 className="text-lg font-semibold text-slate-800 dark:text-white">Plan Distribution</h2>
              <p className="text-sm text-slate-500 dark:text-slate-400">Active subscriptions by plan</p>
            </div>
          </div>
          <div className="space-y-4">
            {planData.map((plan, index) => (
  <div key={index}>

    <div className="flex items-center justify-between mb-1">

      <span className="text-sm font-medium text-slate-700 dark:text-slate-300">
        {plan.plan}
      </span>

      <span className="text-sm text-slate-500">
        {plan.customers} customers
      </span>

    </div>

    <div className="w-full h-3 rounded-full bg-slate-100 dark:bg-slate-700 overflow-hidden">

      <div
        className="h-full rounded-full bg-gradient-to-r from-primary-400 to-primary-500"
        style={{
          width: `${Math.min(plan.customers, 100)}%`,
        }}
      />

    </div>

  </div>
))}
          </div>
        </Card>
      </div>

      {/* Payment Status Overview */}
      <Card>
        <h2 className="text-lg font-semibold text-slate-800 dark:text-white mb-6">
          Payment Status Overview
        </h2>

        <div className="overflow-x-auto">
          <table className="w-full">

            <thead>
              <tr className="border-b border-slate-200 dark:border-slate-700">

                <th className="px-4 py-3 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
                  Plan Name
                </th>

                <th className="px-4 py-3 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
                  Paid
                </th>

                <th className="px-4 py-3 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
                  Pending
                </th>

                <th className="px-4 py-3 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
                  Overdue
                </th>

                <th className="px-4 py-3 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase">
                  Collection Rate
                </th>

              </tr>
            </thead>

            <tbody>

              {paymentData && (
                <tr className="border-b border-slate-100 dark:border-slate-700/50">

                  <td className="px-4 py-3 text-sm font-medium text-slate-800 dark:text-white">
                    Overall
                  </td>

                  <td className="px-4 py-3">
                    <span className="badge badge-success">
                      {paymentData.paid}
                    </span>
                  </td>

                  <td className="px-4 py-3">
                    <span className="badge badge-warning">
                      {paymentData.pending}
                    </span>
                  </td>

                  <td className="px-4 py-3">
                    <span className="badge badge-danger">
                      {paymentData.overdue}
                    </span>
                  </td>

                  <td className="px-4 py-3">
                    Live Data
                  </td>

                </tr>
              )}

            </tbody>

          </table>
        </div>
      </Card>
    </div>
  );
}
```

----------------------------------------

### File: src\pages\admin\SettingsPage.tsx
```tsx
import { useState } from 'react';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button, Input } from '../../components/ui/Form';
import { useAuth } from '../../hooks/useAuth';
import { useTheme } from '../../hooks/useTheme';
import { Save, Moon, Sun, Bell, Lock, Mail, Smartphone } from 'lucide-react';

export default function SettingsPage() {
  const { user } = useAuth();
  const { isDark, toggleTheme } = useTheme();
  const [notifications, setNotifications] = useState({
    email: true,
    sms: false,
    push: true,
    overdueReminders: true,
    newCustomer: true,
  });

  return (
    <div className="space-y-6 animate-fade-in max-w-4xl mx-auto">
      <PageHeader title="Settings" subtitle="Manage your account preferences" />

      {/* Profile Settings */}
      <Card>
        <div className="flex items-center gap-3 mb-6">
          <div className="w-10 h-10 rounded-xl bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center">
            <Lock className="w-5 h-5 text-primary-500" />
          </div>
          <div>
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white">Profile Settings</h2>
            <p className="text-sm text-slate-500 dark:text-slate-400">Update your personal information</p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Input label="Full Name" defaultValue={user?.name} />
          <Input label="Email Address" type="email" defaultValue={user?.email} />
          <Input label="Phone Number" defaultValue={user?.phone} />
          <Input label="Username" defaultValue={user?.username} disabled />
        </div>

        <div className="mt-6 pt-6 border-t border-slate-200 dark:border-slate-700">
          <Button icon={<Save className="w-4 h-4" />}>Save Changes</Button>
        </div>
      </Card>

      {/* Appearance */}
      <Card>
        <div className="flex items-center gap-3 mb-6">
          <div className="w-10 h-10 rounded-xl bg-accent-50 dark:bg-accent-900/20 flex items-center justify-center">
            {isDark ? <Moon className="w-5 h-5 text-accent-500" /> : <Sun className="w-5 h-5 text-accent-500" />}
          </div>
          <div>
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white">Appearance</h2>
            <p className="text-sm text-slate-500 dark:text-slate-400">Customize the interface theme</p>
          </div>
        </div>

        <div className="space-y-4">
          <label className="flex items-center justify-between cursor-pointer">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-slate-100 dark:bg-slate-700 flex items-center justify-center">
                <Moon className="w-4 h-4 text-slate-600 dark:text-slate-300" />
              </div>
              <div>
                <p className="font-medium text-slate-800 dark:text-white">Dark Mode</p>
                <p className="text-sm text-slate-500 dark:text-slate-400">
                  {isDark ? 'Currently enabled' : 'Currently disabled'}
                </p>
              </div>
            </div>
            <button
              onClick={toggleTheme}
              className={`relative w-14 h-7 rounded-full transition-colors ${
                isDark ? 'bg-primary-500' : 'bg-slate-300 dark:bg-slate-600'
              }`}
            >
              <div
                className={`absolute top-1 w-5 h-5 rounded-full bg-white shadow transition-transform ${
                  isDark ? 'translate-x-8' : 'translate-x-1'
                }`}
              />
            </button>
          </label>
        </div>
      </Card>

      {/* Notifications */}
      <Card>
        <div className="flex items-center gap-3 mb-6">
          <div className="w-10 h-10 rounded-xl bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center">
            <Bell className="w-5 h-5 text-blue-500" />
          </div>
          <div>
            <h2 className="text-lg font-semibold text-slate-800 dark:text-white">Notifications</h2>
            <p className="text-sm text-slate-500 dark:text-slate-400">Configure how you receive alerts</p>
          </div>
        </div>

        <div className="space-y-4">
          <label className="flex items-center justify-between cursor-pointer">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-slate-100 dark:bg-slate-700 flex items-center justify-center">
                <Mail className="w-4 h-4 text-slate-600 dark:text-slate-300" />
              </div>
              <div>
                <p className="font-medium text-slate-800 dark:text-white">Email Notifications</p>
                <p className="text-sm text-slate-500 dark:text-slate-400">
                  Receive updates via email
                </p>
              </div>
            </div>
            <input
              type="checkbox"
              checked={notifications.email}
              onChange={(e) => setNotifications({ ...notifications, email: e.target.checked })}
              className="w-5 h-5 rounded text-primary-600"
            />
          </label>

          <label className="flex items-center justify-between cursor-pointer">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-slate-100 dark:bg-slate-700 flex items-center justify-center">
                <Smartphone className="w-4 h-4 text-slate-600 dark:text-slate-300" />
              </div>
              <div>
                <p className="font-medium text-slate-800 dark:text-white">SMS Alerts</p>
                <p className="text-sm text-slate-500 dark:text-slate-400">
                  Get important alerts via SMS
                </p>
              </div>
            </div>
            <input
              type="checkbox"
              checked={notifications.sms}
              onChange={(e) => setNotifications({ ...notifications, sms: e.target.checked })}
              className="w-5 h-5 rounded text-primary-600"
            />
          </label>

          <label className="flex items-center justify-between cursor-pointer">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-slate-100 dark:bg-slate-700 flex items-center justify-center">
                <Bell className="w-4 h-4 text-slate-600 dark:text-slate-300" />
              </div>
              <div>
                <p className="font-medium text-slate-800 dark:text-white">Push Notifications</p>
                <p className="text-sm text-slate-500 dark:text-slate-400">
                  Browser push notifications
                </p>
              </div>
            </div>
            <input
              type="checkbox"
              checked={notifications.push}
              onChange={(e) => setNotifications({ ...notifications, push: e.target.checked })}
              className="w-5 h-5 rounded text-primary-600"
            />
          </label>
        </div>

        <div className="mt-6 pt-6 border-t border-slate-200 dark:border-slate-700">
          <h3 className="font-medium text-slate-800 dark:text-white mb-4">Alert Types</h3>
          <div className="space-y-3">
            <label className="flex items-center gap-3 cursor-pointer">
              <input
                type="checkbox"
                checked={notifications.overdueReminders}
                onChange={(e) =>
                  setNotifications({ ...notifications, overdueReminders: e.target.checked })
                }
                className="w-5 h-5 rounded text-primary-600"
              />
              <span className="text-sm text-slate-700 dark:text-slate-300">Overdue payment reminders</span>
            </label>
            <label className="flex items-center gap-3 cursor-pointer">
              <input
                type="checkbox"
                checked={notifications.newCustomer}
                onChange={(e) =>
                  setNotifications({ ...notifications, newCustomer: e.target.checked })
                }
                className="w-5 h-5 rounded text-primary-600"
              />
              <span className="text-sm text-slate-700 dark:text-slate-300">New customer onboarded</span>
            </label>
          </div>
        </div>
      </Card>

      {/* Danger Zone */}
      <Card className="border-red-200 dark:border-red-900/50">
        <h2 className="text-lg font-semibold text-red-600 dark:text-red-400 mb-4">Danger Zone</h2>
        <p className="text-sm text-slate-600 dark:text-slate-400 mb-4">
          These actions are irreversible. Please proceed with caution.
        </p>
        <div className="flex gap-3">
          <Button variant="danger">Delete Account</Button>
          <Button variant="secondary">Export Data</Button>
        </div>
      </Card>
    </div>
  );
}

```

----------------------------------------

### File: src\pages\admin\SubscriptionsPage.tsx
```tsx
import { useCallback, useEffect, useState } from 'react';
import { Table, Pagination, SearchBar } from '../../components/ui/Table';
import { Card, PageHeader } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { StatusBadge } from '../../components/ui/Badge';
import { Modal } from '../../components/ui/Modal';
import { Subscription, Customer, ChitPlan } from '../../types';
import { UserPlus, Calendar } from 'lucide-react';
import {
  createSubscription,
  fetchChitPlans,
  fetchCustomers,
  fetchSubscriptions,
  mapApiError,
} from '../../services/api';

const PAGE_SIZE = 10;

export default function SubscriptionsPage() {
  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [subscriptions, setSubscriptions] = useState<Subscription[]>([]);
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [chitPlans, setChitPlans] = useState<ChitPlan[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [formData, setFormData] = useState({
    customerId: '',
    chitPlanId: '',
    joinedDate: new Date().toISOString().split('T')[0],
  });

  const loadSubscriptions = useCallback(async () => {
    setIsLoading(true);
    setError('');
    try {
      const data = await fetchSubscriptions(search ? { search } : {});
      setSubscriptions(data);
      setCurrentPage(1);
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsLoading(false);
    }
  }, [search]);

  useEffect(() => {
    const timer = setTimeout(() => {
      loadSubscriptions();
    }, 300);
    return () => clearTimeout(timer);
  }, [loadSubscriptions]);

  useEffect(() => {
    if (!showModal) return;
    Promise.all([fetchCustomers(), fetchChitPlans()])
      .then(([customerData, planData]) => {
        setCustomers(customerData);
        setChitPlans(planData.filter((p) => p.isActive));
      })
      .catch((err) => setError(mapApiError(err)));
  }, [showModal]);

  const paginatedSubscriptions = subscriptions.slice(
    (currentPage - 1) * PAGE_SIZE,
    currentPage * PAGE_SIZE,
  );

  const handleEnroll = async () => {
    if (!formData.customerId || !formData.chitPlanId) {
      setError('Please select both a customer and a chit plan.');
      return;
    }

    setIsSaving(true);
    setError('');
    try {
      await createSubscription({
        customerId: formData.customerId,
        chitPlanId: formData.chitPlanId,
        joinedDate: formData.joinedDate,
      });
      setShowModal(false);
      setFormData({
        customerId: '',
        chitPlanId: '',
        joinedDate: new Date().toISOString().split('T')[0],
      });
      await loadSubscriptions();
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsSaving(false);
    }
  };

  const columns = [
    {
      key: 'customerName',
      header: 'Customer',
      render: (sub: Subscription) => (
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-gradient-to-br from-primary-400 to-primary-500 flex items-center justify-center text-white font-semibold">
            {sub.customerName.charAt(0)}
          </div>
          <p className="font-medium text-slate-800 dark:text-white">{sub.customerName}</p>
        </div>
      ),
    },
    {
      key: 'chitPlanName',
      header: 'Chit Plan',
    },
    {
      key: 'joinedDate',
      header: 'Joined Date',
      render: (sub: Subscription) => (
        <div className="flex items-center gap-1.5">
          <Calendar className="w-4 h-4 text-slate-400" />
          <span className="text-slate-700 dark:text-slate-300">
            {new Date(sub.joinedDate).toLocaleDateString()}
          </span>
        </div>
      ),
    },
    {
      key: 'status',
      header: 'Status',
      render: (sub: Subscription) => <StatusBadge status={sub.status} />,
    },
    {
      key: 'paymentStatus',
      header: 'Payment',
      render: (sub: Subscription) => <StatusBadge status={sub.paymentStatus} />,
    },
  ];

  return (
    <div className="space-y-6 animate-fade-in">
      <PageHeader
        title="Subscriptions"
        subtitle="Manage customer subscriptions"
        action={
          <Button icon={<UserPlus className="w-4 h-4" />} onClick={() => setShowModal(true)}>
            Enroll Customer
          </Button>
        }
      />

      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      <Card>
        <div className="flex flex-col sm:flex-row gap-4 mb-4">
          <SearchBar value={search} onChange={setSearch} placeholder="Search subscriptions..." />
        </div>

        {isLoading ? (
          <div className="flex justify-center py-16">
            <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : (
          <>
            <Table<Subscription>
              columns={columns}
              data={paginatedSubscriptions}
              keyExtractor={(s: Subscription) => s.id}
              emptyMessage="No subscriptions found"
            />

            <Pagination
              currentPage={currentPage}
              totalPages={Math.max(1, Math.ceil(subscriptions.length / PAGE_SIZE))}
              onPageChange={setCurrentPage}
            />
          </>
        )}
      </Card>

      <Modal
        isOpen={showModal}
        onClose={() => setShowModal(false)}
        title="Enroll Customer in Chit Plan"
      >
        <div className="space-y-4">
          <div>
            <label className="form-label">Select Customer</label>
            <select
              value={formData.customerId}
              onChange={(e) => setFormData({ ...formData, customerId: e.target.value })}
              className="glass-input w-full py-2.5 px-4"
            >
              <option value="">Choose customer...</option>
              {customers.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name} ({c.customerId})
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="form-label">Select Chit Plan</label>
            <select
              value={formData.chitPlanId}
              onChange={(e) => setFormData({ ...formData, chitPlanId: e.target.value })}
              className="glass-input w-full py-2.5 px-4"
            >
              <option value="">Choose plan...</option>
              {chitPlans.map((p) => (
                <option key={p.id} value={p.id}>
                  {p.planName} - ₹{p.monthlyPayment}/month
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="form-label">Joined Date</label>
            <input
              type="date"
              value={formData.joinedDate}
              onChange={(e) => setFormData({ ...formData, joinedDate: e.target.value })}
              className="glass-input w-full py-2.5 px-4"
            />
          </div>
        </div>

        <div className="flex gap-3 justify-end mt-6">
          <Button variant="secondary" onClick={() => setShowModal(false)}>
            Cancel
          </Button>
          <Button onClick={handleEnroll} isLoading={isSaving}>
            Enroll Now
          </Button>
        </div>
      </Modal>
    </div>
  );
}

```

----------------------------------------

### File: src\pages\agent\AddCustomerPage.tsx
```tsx
import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Card } from '../../components/ui/Card';
import { Input, Button } from '../../components/ui/Form';
import { AddressForm } from '../../components/ui/AddressForm';
import { PhotoUpload } from '../../components/ui/PhotoUpload';
import { ArrowLeft, Save, MapPin } from 'lucide-react';
import { createCustomerWithDetails, fetchChitPlans, mapApiError } from '../../services/api';
import { ChitPlan } from '../../types';

export default function AddCustomerPage() {
  const navigate = useNavigate();
  const [step, setStep] = useState(1);
  const totalSteps = 4;
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState('');
  const [chitPlans, setChitPlans] = useState<ChitPlan[]>([]);

  const [customer, setCustomer] = useState({
    name: '',
    primaryMobile: '',
    alternateMobile: '',
    email: '',
  });

  const [homeAddress, setHomeAddress] = useState({
    id: '',
    type: 'home' as const,
    houseOrBuildingName: '',
    landmark: '',
    village: '',
    taluk: '',
    district: '',
    state: '',
    pinCode: '',
    latitude: null as number | null,
    longitude: null as number | null,
    mapUrl: '',
  });

  const [workAddress, setWorkAddress] = useState({
    id: '',
    type: 'work' as const,
    houseOrBuildingName: '',
    landmark: '',
    village: '',
    taluk: '',
    district: '',
    state: '',
    pinCode: '',
    latitude: null as number | null,
    longitude: null as number | null,
    mapUrl: '',
  });

  const [photos, setPhotos] = useState({
    customer: '',
    addressProof: '',
    idProof: '',
    workLocation: '',
  });

  const [subscription, setSubscription] = useState({
    chitPlanId: '',
    joinedDate: new Date().toISOString().split('T')[0],
  });

  const [addWorkAddress, setAddWorkAddress] = useState(false);

  useEffect(() => {
    fetchChitPlans()
      .then((plans) => setChitPlans(plans.filter((p) => p.isActive)))
      .catch(() => {});
  }, []);

  const canProceed = () => {
    switch (step) {
      case 1:
        return customer.name && customer.primaryMobile;
      case 2:
        return homeAddress.houseOrBuildingName && homeAddress.district && homeAddress.state && homeAddress.pinCode;
      case 3:
        return photos.customer && photos.idProof;
      case 4:
        return true;
      default:
        return false;
    }
  };

  const handleSave = async () => {
    setError('');
    setIsSaving(true);
    try {
      await createCustomerWithDetails({
        customer,
        homeAddress,
        workAddress: addWorkAddress ? workAddress : null,
        photos,
        subscription: subscription.chitPlanId ? subscription : null,
      });
      navigate('/agent');
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsSaving(false);
    }
  };

  const handleGetCurrentLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const { latitude, longitude } = position.coords;
          setHomeAddress({
            ...homeAddress,
            latitude,
            longitude,
            mapUrl: `https://maps.google.com/?q=${latitude},${longitude}`,
          });
        },
        (locationError) => console.error('Error getting location:', locationError),
      );
    }
  };

  return (
    <div className="space-y-4 animate-fade-in">
      <div className="flex items-center gap-3 mb-4">
        <button
          onClick={() => (step > 1 ? setStep(step - 1) : navigate(-1))}
          className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <div className="flex-1">
          <h1 className="text-lg font-bold text-slate-800 dark:text-white">Add Customer</h1>
          <p className="text-xs text-slate-500 dark:text-slate-400">
            Step {step} of {totalSteps}
          </p>
        </div>
      </div>

      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      <div className="flex gap-1">
        {Array.from({ length: totalSteps }).map((_, i) => (
          <div
            key={i}
            className={`flex-1 h-1.5 rounded-full ${
              i < step
                ? 'bg-primary-500'
                : i === step - 1
                ? 'bg-primary-300 dark:bg-primary-700'
                : 'bg-slate-200 dark:bg-slate-700'
            }`}
          />
        ))}
      </div>

      <div className="mt-6">
        {step === 1 && (
          <Card className="p-4 space-y-4">
            <h2 className="text-base font-semibold text-slate-800 dark:text-white">
              Personal Details
            </h2>
            <Input
              label="Full Name"
              placeholder="Customer name"
              value={customer.name}
              onChange={(e) => setCustomer({ ...customer, name: e.target.value })}
              required
            />
            <Input
              label="Mobile Number"
              placeholder="+91 XXXXX XXXXX"
              value={customer.primaryMobile}
              onChange={(e) => setCustomer({ ...customer, primaryMobile: e.target.value })}
              required
            />
            <Input
              label="Alternate Mobile (Optional)"
              placeholder="+91 XXXXX XXXXX"
              value={customer.alternateMobile}
              onChange={(e) => setCustomer({ ...customer, alternateMobile: e.target.value })}
            />
            <Input
              label="Email Address"
              type="email"
              placeholder="customer@email.com"
              value={customer.email}
              onChange={(e) => setCustomer({ ...customer, email: e.target.value })}
            />
          </Card>
        )}

        {step === 2 && (
          <div className="space-y-4">
            <Card className="p-4">
              <div className="flex items-center justify-between mb-4">
                <h2 className="text-base font-semibold text-slate-800 dark:text-white">
                  Home Address
                </h2>
                <button
                  type="button"
                  onClick={handleGetCurrentLocation}
                  className="flex items-center gap-1.5 text-xs text-primary-600 dark:text-primary-400"
                >
                  <MapPin className="w-4 h-4" />
                  Use GPS
                </button>
              </div>
              <AddressForm
                type="home"
                data={homeAddress}
                onChange={(data) => setHomeAddress({ ...homeAddress, ...data })}
                compact
              />
            </Card>

            <label className="flex items-center gap-3 p-4 glass-card cursor-pointer">
              <input
                type="checkbox"
                checked={addWorkAddress}
                onChange={(e) => setAddWorkAddress(e.target.checked)}
                className="w-5 h-5 rounded text-primary-600"
              />
              <div>
                <p className="font-medium text-slate-800 dark:text-white">
                  Add Work Address
                </p>
                <p className="text-xs text-slate-500 dark:text-slate-400">
                  Include workplace location
                </p>
              </div>
            </label>

            {addWorkAddress && (
              <Card className="p-4">
                <h2 className="text-base font-semibold text-slate-800 dark:text-white mb-4">
                  Work Address
                </h2>
                <AddressForm
                  type="work"
                  data={workAddress}
                  onChange={(data) => setWorkAddress({ ...workAddress, ...data })}
                  compact
                />
              </Card>
            )}
          </div>
        )}

        {step === 3 && (
          <Card className="p-4 space-y-4">
            <h2 className="text-base font-semibold text-slate-800 dark:text-white">
              Photo Uploads
            </h2>
            <div className="grid grid-cols-3 gap-3">
              <PhotoUpload
                type="customer"
                label="Photo"
                value={photos.customer}
                onChange={(url) => setPhotos({ ...photos, customer: url })}
                compact
              />
              <PhotoUpload
                type="id_proof"
                label="ID Proof"
                value={photos.idProof}
                onChange={(url) => setPhotos({ ...photos, idProof: url })}
                compact
              />
              <PhotoUpload
                type="address_proof"
                label="Address"
                value={photos.addressProof}
                onChange={(url) => setPhotos({ ...photos, addressProof: url })}
                compact
              />
            </div>
          </Card>
        )}

        {step === 4 && (
          <Card className="p-4 space-y-4">
            <h2 className="text-base font-semibold text-slate-800 dark:text-white">
              Chit Plan Enrollment
            </h2>
            <div>
              <label className="form-label">Select Plan (Optional)</label>
              <select
                value={subscription.chitPlanId}
                onChange={(e) => setSubscription({ ...subscription, chitPlanId: e.target.value })}
                className="glass-input w-full py-2.5 px-4"
              >
                <option value="">Choose a plan...</option>
                {chitPlans.map((p) => (
                  <option key={p.id} value={p.id}>
                    {p.planName} - ₹{p.monthlyPayment}/month
                  </option>
                ))}
              </select>
            </div>

            <div className="mt-6 pt-6 border-t border-slate-200 dark:border-slate-700">
              <h3 className="text-sm font-medium text-slate-700 dark:text-slate-300 mb-3">
                Summary
              </h3>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-slate-500 dark:text-slate-400">Name</span>
                  <span className="text-slate-800 dark:text-white font-medium">{customer.name}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-500 dark:text-slate-400">Mobile</span>
                  <span className="text-slate-800 dark:text-white font-medium">{customer.primaryMobile}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-500 dark:text-slate-400">Location</span>
                  <span className="text-slate-800 dark:text-white font-medium">{homeAddress.district}</span>
                </div>
              </div>
            </div>
          </Card>
        )}
      </div>

      <div className="fixed bottom-20 left-0 right-0 p-4 bg-transparent">
        <div className="max-w-lg mx-auto flex gap-3">
          {step < totalSteps ? (
            <Button
              className="flex-1"
              onClick={() => setStep(step + 1)}
              disabled={!canProceed()}
            >
              Continue
            </Button>
          ) : (
            <Button
              className="flex-1"
              icon={<Save className="w-4 h-4" />}
              onClick={handleSave}
              isLoading={isSaving}
            >
              Save Customer
            </Button>
          )}
        </div>
      </div>
    </div>
  );
}

```

----------------------------------------

### File: src\pages\agent\CustomerDetailPage.tsx
```tsx
import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Card } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { StatusBadge } from '../../components/ui/Badge';
import { Customer, Subscription } from '../../types';
import { fetchCustomer, fetchSubscriptions, mapApiError } from '../../services/api';
import { ArrowLeft, Phone, Mail, MapPin, Navigation, CreditCard } from 'lucide-react';

export default function AgentCustomerDetailPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [customer, setCustomer] = useState<Customer | null>(null);
  const [subscriptions, setSubscriptions] = useState<Subscription[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    if (!id) return;
    setIsLoading(true);
    Promise.all([
      fetchCustomer(id),
      fetchSubscriptions({ customer: id }),
    ])
      .then(([customerData, subscriptionData]) => {
        setCustomer(customerData);
        setSubscriptions(subscriptionData);
      })
      .catch((err) => setError(mapApiError(err)))
      .finally(() => setIsLoading(false));
  }, [id]);

  if (isLoading) {
    return (
      <div className="flex justify-center py-24">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!customer) {
    return (
      <div className="text-center py-16">
        <p className="text-slate-500 dark:text-slate-400">Customer not found</p>
        <Button className="mt-4" onClick={() => navigate('/agent')}>
          Back to Customers
        </Button>
      </div>
    );
  }

  const getPhotoUrl = (type: string) => {
    return customer.photos.find((p) => p.type === type)?.url;
  };

  return (
    <div className="space-y-4 animate-fade-in pb-24">
      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      {/* Header */}
      <div className="flex items-center gap-3 mb-4">
        <button
          onClick={() => navigate(-1)}
          className="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <h1 className="text-lg font-bold text-slate-800 dark:text-white">Customer Details</h1>
      </div>

      {/* Profile Card */}
      <Card className="p-4 text-center">
        <img
          src={getPhotoUrl('customer') || `https://ui-avatars.com/api/?name=${encodeURIComponent(customer.name)}&background=3b82f6&color=fff&size=128`}
          alt={customer.name}
          className="w-20 h-20 rounded-full mx-auto mb-3 object-cover"
        />
        <h2 className="text-xl font-bold text-slate-800 dark:text-white">{customer.name}</h2>
        <p className="text-sm text-slate-500 dark:text-slate-400">{customer.customerId}</p>
      </Card>

      {/* Contact Info */}
      <Card className="p-4">
        <h3 className="font-semibold text-slate-800 dark:text-white mb-3">Contact Info</h3>
        <div className="space-y-3">
          <a
            href={`tel:${customer.primaryMobile}`}
            className="flex items-center gap-3 text-slate-600 dark:text-slate-300"
          >
            <div className="w-8 h-8 rounded-lg bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center">
              <Phone className="w-4 h-4 text-primary-500" />
            </div>
            <span>{customer.primaryMobile}</span>
          </a>
          {customer.alternateMobile && (
            <a
              href={`tel:${customer.alternateMobile}`}
              className="flex items-center gap-3 text-slate-600 dark:text-slate-300"
            >
              <div className="w-8 h-8 rounded-lg bg-slate-100 dark:bg-slate-700 flex items-center justify-center">
                <Phone className="w-4 h-4 text-slate-500" />
              </div>
              <span>{customer.alternateMobile}</span>
            </a>
          )}
          <a
            href={`mailto:${customer.email}`}
            className="flex items-center gap-3 text-slate-600 dark:text-slate-300"
          >
            <div className="w-8 h-8 rounded-lg bg-accent-50 dark:bg-accent-900/20 flex items-center justify-center">
              <Mail className="w-4 h-4 text-accent-500" />
            </div>
            <span className="text-sm">{customer.email}</span>
          </a>
        </div>
      </Card>

      {/* Home Address */}
      <Card className="p-4">
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center gap-2">
            <MapPin className="w-5 h-5 text-primary-500" />
            <h3 className="font-semibold text-slate-800 dark:text-white">Home Address</h3>
          </div>
          <button
            onClick={() => window.open(customer.homeAddress.mapUrl, '_blank')}
            className="flex items-center gap-1.5 text-sm text-primary-600 dark:text-primary-400"
          >
            <Navigation className="w-4 h-4" />
            Navigate
          </button>
        </div>
        <p className="text-sm text-slate-600 dark:text-slate-300">
          {customer.homeAddress.houseOrBuildingName}
          {customer.homeAddress.landmark && `, ${customer.homeAddress.landmark}`}
        </p>
        <p className="text-sm text-slate-500 dark:text-slate-400">
          {customer.homeAddress.village}, {customer.homeAddress.taluk}
        </p>
        <p className="text-sm text-slate-500 dark:text-slate-400">
          {customer.homeAddress.district}, {customer.homeAddress.state} - {customer.homeAddress.pinCode}
        </p>
      </Card>

      {/* Work Address */}
      {customer.workAddress && (
        <Card className="p-4">
          <div className="flex items-center justify-between mb-3">
            <div className="flex items-center gap-2">
              <MapPin className="w-5 h-5 text-accent-500" />
              <h3 className="font-semibold text-slate-800 dark:text-white">Work Address</h3>
            </div>
            <button
              onClick={() => window.open(customer.workAddress?.mapUrl, '_blank')}
              className="flex items-center gap-1.5 text-sm text-primary-600 dark:text-primary-400"
            >
              <Navigation className="w-4 h-4" />
              Navigate
            </button>
          </div>
          <p className="text-sm text-slate-600 dark:text-slate-300">
            {customer.workAddress.houseOrBuildingName}
          </p>
          <p className="text-sm text-slate-500 dark:text-slate-400">
            {customer.workAddress.district}, {customer.workAddress.state}
          </p>
        </Card>
      )}

      {/* Photos */}
      <Card className="p-4">
        <h3 className="font-semibold text-slate-800 dark:text-white mb-3">Documents</h3>
        <div className="grid grid-cols-3 gap-2">
          {customer.photos.map((photo, index) => (
            <div key={index} className="aspect-square rounded-xl overflow-hidden bg-slate-100 dark:bg-slate-700">
              <img
                src={photo.url}
                alt={photo.type}
                className="w-full h-full object-cover"
              />
            </div>
          ))}
        </div>
      </Card>

      {/* Subscriptions */}
      <Card className="p-4">
        <div className="flex items-center gap-2 mb-3">
          <CreditCard className="w-5 h-5 text-primary-500" />
          <h3 className="font-semibold text-slate-800 dark:text-white">Subscriptions</h3>
        </div>
        {subscriptions.length === 0 ? (
          <p className="text-sm text-slate-500 dark:text-slate-400">No active subscriptions</p>
        ) : (
          <div className="space-y-3">
            {subscriptions.map((sub) => (
              <div key={sub.id} className="p-3 rounded-xl bg-slate-50 dark:bg-slate-700/50">
                <div className="flex items-center justify-between mb-2">
                  <p className="font-medium text-slate-800 dark:text-white">{sub.chitPlanName}</p>
                  <StatusBadge status={sub.status} />
                </div>
                <div className="flex items-center justify-between text-xs">
                  <span className="text-slate-500 dark:text-slate-400">Payment</span>
                  <StatusBadge status={sub.paymentStatus} />
                </div>
              </div>
            ))}
          </div>
        )}
      </Card>
    </div>
  );
}

```

----------------------------------------

### File: src\pages\agent\EnrollPage.tsx
```tsx
import { useEffect, useState } from 'react';
import { Card } from '../../components/ui/Card';
import { Button } from '../../components/ui/Form';
import { CreditCard, IndianRupee, UserPlus } from 'lucide-react';
import {
  createSubscription,
  fetchChitPlans,
  fetchCustomers,
  mapApiError,
} from '../../services/api';
import { ChitPlan, Customer } from '../../types';

export default function EnrollPage() {
  const [step, setStep] = useState(1);
  const [selectedCustomer, setSelectedCustomer] = useState('');
  const [selectedPlan, setSelectedPlan] = useState('');
  const [success, setSuccess] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState('');
  const [myCustomers, setMyCustomers] = useState<Customer[]>([]);
  const [activePlans, setActivePlans] = useState<ChitPlan[]>([]);

  useEffect(() => {
    Promise.all([fetchCustomers(), fetchChitPlans()])
      .then(([customers, plans]) => {
        setMyCustomers(customers);
        setActivePlans(plans.filter((p) => p.isActive));
      })
      .catch((err) => setError(mapApiError(err)))
      .finally(() => setIsLoading(false));
  }, []);

  const customer = myCustomers.find((c) => c.id === selectedCustomer);
  const plan = activePlans.find((p) => p.id === selectedPlan);

  const handleEnroll = async () => {
    if (!selectedCustomer || !selectedPlan) return;

    setIsSaving(true);
    setError('');
    try {
      await createSubscription({
        customerId: selectedCustomer,
        chitPlanId: selectedPlan,
        joinedDate: new Date().toISOString().split('T')[0],
      });
      setSuccess(true);
      setTimeout(() => {
        setSuccess(false);
        setSelectedCustomer('');
        setSelectedPlan('');
        setStep(1);
      }, 2000);
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsSaving(false);
    }
  };

  if (success) {
    return (
      <div className="flex flex-col items-center justify-center py-16 animate-fade-in">
        <div className="w-20 h-20 rounded-full bg-gradient-to-br from-accent-400 to-accent-500 flex items-center justify-center mb-4 shadow-lg shadow-accent-500/30 animate-scale-in">
          <svg className="w-10 h-10 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
          </svg>
        </div>
        <h2 className="text-xl font-bold text-slate-800 dark:text-white mb-2">
          Enrollment Successful!
        </h2>
        <p className="text-slate-500 dark:text-slate-400 text-center">
          {customer?.name} has been enrolled in {plan?.planName}
        </p>
      </div>
    );
  }

  if (isLoading) {
    return (
      <div className="flex justify-center py-24">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-4 animate-fade-in">
      <div className="text-center mb-6">
        <h1 className="text-xl font-bold text-slate-800 dark:text-white">Enroll Customer</h1>
        <p className="text-sm text-slate-500 dark:text-slate-400">
          Subscribe a customer to a chit plan
        </p>
      </div>

      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      <div className="flex gap-1 mb-6">
        {[1, 2].map((s) => (
          <div
            key={s}
            className={`flex-1 h-1.5 rounded-full ${
              s <= step
                ? 'bg-primary-500'
                : 'bg-slate-200 dark:bg-slate-700'
            }`}
          />
        ))}
      </div>

      {step === 1 && (
        <Card className="p-4 space-y-4">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-10 h-10 rounded-xl bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center">
              <CreditCard className="w-5 h-5 text-primary-500" />
            </div>
            <div>
              <h2 className="font-semibold text-slate-800 dark:text-white">Select Customer</h2>
              <p className="text-xs text-slate-500 dark:text-slate-400">Choose from your customers</p>
            </div>
          </div>

          <div className="space-y-2">
            {myCustomers.length === 0 ? (
              <p className="text-center text-slate-500 dark:text-slate-400 py-4">
                No customers available
              </p>
            ) : (
              myCustomers.map((c) => (
                <label
                  key={c.id}
                  className={`flex items-center gap-3 p-3 rounded-xl cursor-pointer transition-all ${
                    selectedCustomer === c.id
                      ? 'bg-primary-50 dark:bg-primary-900/20 border-2 border-primary-500'
                      : 'bg-slate-50 dark:bg-slate-700/50 border-2 border-transparent hover:bg-slate-100 dark:hover:bg-slate-700'
                  }`}
                >
                  <input
                    type="radio"
                    name="customer"
                    checked={selectedCustomer === c.id}
                    onChange={() => setSelectedCustomer(c.id)}
                    className="sr-only"
                  />
                  <img
                    src={`https://ui-avatars.com/api/?name=${encodeURIComponent(c.name)}&background=3b82f6&color=fff`}
                    alt={c.name}
                    className="w-10 h-10 rounded-full"
                  />
                  <div className="flex-1">
                    <p className="font-medium text-slate-800 dark:text-white">{c.name}</p>
                    <p className="text-xs text-slate-500 dark:text-slate-400">{c.customerId}</p>
                  </div>
                </label>
              ))
            )}
          </div>

          <Button
            className="w-full mt-4"
            onClick={() => setStep(2)}
            disabled={!selectedCustomer}
          >
            Next: Select Plan
          </Button>
        </Card>
      )}

      {step === 2 && (
        <Card className="p-4 space-y-4">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-10 h-10 rounded-xl bg-accent-50 dark:bg-accent-900/20 flex items-center justify-center">
              <IndianRupee className="w-5 h-5 text-accent-500" />
            </div>
            <div>
              <h2 className="font-semibold text-slate-800 dark:text-white">Select Chit Plan</h2>
              <p className="text-xs text-slate-500 dark:text-slate-400">Choose a savings plan</p>
            </div>
          </div>

          {customer && (
            <div className="flex items-center gap-3 p-3 rounded-xl bg-slate-50 dark:bg-slate-700/50">
              <img
                src={`https://ui-avatars.com/api/?name=${encodeURIComponent(customer.name)}&background=3b82f6&color=fff`}
                alt={customer.name}
                className="w-8 h-8 rounded-full"
              />
              <div className="flex-1">
                <p className="text-sm font-medium text-slate-800 dark:text-white">{customer.name}</p>
                <p className="text-xs text-slate-500 dark:text-slate-400">{customer.customerId}</p>
              </div>
            </div>
          )}

          <div className="space-y-2">
            {activePlans.map((p) => (
              <label
                key={p.id}
                className={`block p-4 rounded-xl cursor-pointer transition-all ${
                  selectedPlan === p.id
                    ? 'bg-accent-50 dark:bg-accent-900/20 border-2 border-accent-500'
                    : 'bg-slate-50 dark:bg-slate-700/50 border-2 border-transparent hover:bg-slate-100 dark:hover:bg-slate-700'
                }`}
              >
                <div className="flex items-start justify-between">
                  <div>
                    <p className="font-semibold text-slate-800 dark:text-white">{p.planName}</p>
                    <p className="text-xs text-slate-500 dark:text-slate-400">{p.planCode}</p>
                  </div>
                  <div className="text-right">
                    <p className="font-bold text-lg text-accent-600 dark:text-accent-400">
                      ₹{p.monthlyPayment.toLocaleString()}
                    </p>
                    <p className="text-xs text-slate-500 dark:text-slate-400">/month</p>
                  </div>
                </div>
                <div className="flex items-center gap-4 mt-2 text-xs text-slate-500 dark:text-slate-400">
                  <span>Total: ₹{p.totalAmount.toLocaleString()}</span>
                  <span>{p.numberOfInstallments} months</span>
                </div>
                <input
                  type="radio"
                  name="plan"
                  checked={selectedPlan === p.id}
                  onChange={() => setSelectedPlan(p.id)}
                  className="sr-only"
                />
              </label>
            ))}
          </div>

          <div className="flex gap-3 mt-4">
            <Button variant="secondary" className="flex-1" onClick={() => setStep(1)}>
              Back
            </Button>
            <Button
              className="flex-1"
              icon={<UserPlus className="w-4 h-4" />}
              onClick={handleEnroll}
              disabled={!selectedPlan}
              isLoading={isSaving}
            >
              Enroll Now
            </Button>
          </div>
        </Card>
      )}
    </div>
  );
}

```

----------------------------------------

### File: src\pages\agent\MyCustomersPage.tsx
```tsx
import { useCallback, useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Card } from '../../components/ui/Card';
import { SearchBar } from '../../components/ui/Table';
import { Phone, MapPin, Navigation } from 'lucide-react';
import { fetchCustomers, mapApiError } from '../../services/api';
import { Customer } from '../../types';

export default function MyCustomersPage() {
  const navigate = useNavigate();
  const [search, setSearch] = useState('');
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');

  const loadCustomers = useCallback(async () => {
    setIsLoading(true);
    setError('');
    try {
      const data = await fetchCustomers(search ? { search } : {});
      setCustomers(data);
    } catch (err) {
      setError(mapApiError(err));
    } finally {
      setIsLoading(false);
    }
  }, [search]);

  useEffect(() => {
    const timer = setTimeout(() => {
      loadCustomers();
    }, 300);
    return () => clearTimeout(timer);
  }, [loadCustomers]);

  return (
    <div className="space-y-4 animate-fade-in">
      <div className="text-center mb-6">
        <h1 className="text-xl font-bold text-slate-800 dark:text-white">My Customers</h1>
        <p className="text-sm text-slate-500 dark:text-slate-400">
          {customers.length} customers onboarded
        </p>
      </div>

      <SearchBar
        value={search}
        onChange={setSearch}
        placeholder="Search customers..."
      />

      {error && (
        <div className="p-3 rounded-xl bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm">
          {error}
        </div>
      )}

      {isLoading ? (
        <div className="flex justify-center py-16">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : (
        <div className="space-y-3">
          {customers.length === 0 ? (
            <Card className="text-center py-8">
              <p className="text-slate-500 dark:text-slate-400">No customers found</p>
            </Card>
          ) : (
            customers.map((customer) => (
              <Card
                key={customer.id}
                className="p-4"
                onClick={() => navigate(`/agent/customer/${customer.id}`)}
              >
                <div className="flex items-start gap-3">
                  <img
                    src={`https://ui-avatars.com/api/?name=${encodeURIComponent(customer.name)}&background=3b82f6&color=fff`}
                    alt={customer.name}
                    className="w-12 h-12 rounded-full"
                  />
                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between">
                      <div>
                        <h3 className="font-semibold text-slate-800 dark:text-white">
                          {customer.name}
                        </h3>
                        <p className="text-xs text-slate-500 dark:text-slate-400">
                          {customer.customerId}
                        </p>
                      </div>
                      {customer.homeAddress.mapUrl && (
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            window.open(customer.homeAddress.mapUrl, '_blank');
                          }}
                          className="p-2 rounded-lg bg-primary-50 dark:bg-primary-900/20 text-primary-600 dark:text-primary-400"
                        >
                          <Navigation className="w-5 h-5" />
                        </button>
                      )}
                    </div>

                    <div className="mt-3 flex flex-wrap gap-3 text-xs">
                      <div className="flex items-center gap-1 text-slate-600 dark:text-slate-300">
                        <Phone className="w-3.5 h-3.5" />
                        {customer.primaryMobile}
                      </div>
                      {customer.homeAddress.district && (
                        <div className="flex items-center gap-1 text-slate-500 dark:text-slate-400">
                          <MapPin className="w-3.5 h-3.5" />
                          {customer.homeAddress.district}
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              </Card>
            ))
          )}
        </div>
      )}
    </div>
  );
}

```

----------------------------------------

### File: src\services\api.d.ts
```ts
import type { ChitPlan, Customer, Subscription, User } from '../types';

export function getAccessToken(): string | null;
export function getRefreshToken(): string | null;
export function getStoredUser(): User | null;
export function setAuthData(data: { access: string; refresh: string; user: User }): void;
export function clearAuthData(): void;
export function mapBackendRole(role: string): 'admin' | 'agent';
export function mapApiError(error: unknown): string;
export function mapCustomerFromApi(customer: Record<string, unknown>): Customer;
export function mapChitPlanFromApi(plan: Record<string, unknown>): ChitPlan;
export function mapSubscriptionFromApi(subscription: Record<string, unknown>): Subscription;

export function login(username: string, password: string): Promise<User>;
export function fetchCustomers(params?: Record<string, string>): Promise<Customer[]>;
export function fetchCustomer(id: string): Promise<Customer>;
export function createCustomerWithDetails(data: {
  customer: {
    name: string;
    primaryMobile: string;
    alternateMobile?: string;
    email?: string;
  };
  homeAddress: Record<string, unknown>;
  workAddress?: Record<string, unknown> | null;
  photos?: Record<string, string>;
  subscription?: { chitPlanId: string; joinedDate?: string } | null;
}): Promise<Customer>;
export function updateCustomer(
  id: string,
  customer: {
    name: string;
    primaryMobile: string;
    alternateMobile?: string;
    email?: string;
  },
): Promise<Customer>;
export function deleteCustomer(id: string): Promise<void>;
export function fetchChitPlans(params?: Record<string, string>): Promise<ChitPlan[]>;
export function createChitPlan(plan: {
  planName: string;
  planCode: string;
  totalAmount: number;
  numberOfInstallments: number;
  monthlyPayment: number;
}): Promise<ChitPlan>;
export function updateChitPlan(
  id: string,
  plan: {
    planName: string;
    planCode: string;
    totalAmount: number;
    numberOfInstallments: number;
    monthlyPayment: number;
    isActive: boolean;
  },
): Promise<ChitPlan>;
export function toggleChitPlanActive(id: string, isActive: boolean): Promise<ChitPlan>;
export function fetchSubscriptions(params?: Record<string, string>): Promise<Subscription[]>;
export function mapDashboardStatsFromApi(data: Record<string, unknown>): import('../types').DashboardStats;
export function fetchDashboardStats(): Promise<import('../types').DashboardStats>;
export function mapDashboardRecentCustomerFromApi(
  customer: Record<string, unknown>,
): import('../types').DashboardRecentCustomer;
export function fetchDashboardRecentCustomers(): Promise<
  import('../types').DashboardRecentCustomer[]
>;
export function mapDashboardRecentSubscriptionFromApi(
  subscription: Record<string, unknown>,
): import('../types').DashboardRecentSubscription;
export function fetchDashboardRecentSubscriptions(): Promise<
  import('../types').DashboardRecentSubscription[]
>;
export function createSubscription(data: {
  customerId: string;
  chitPlanId: string;
  joinedDate: string;
}): Promise<Subscription>;

declare const api: import('axios').AxiosInstance;
export default api;

```

----------------------------------------

### File: src\services\api.js
```js
import axios from 'axios';

const API_BASE_URL = 'http://127.0.0.1:8000/api/';

const ACCESS_TOKEN_KEY = 'chitty_access_token';
const REFRESH_TOKEN_KEY = 'chitty_refresh_token';
const USER_KEY = 'chitty_user';

let isRefreshing = false;
let refreshSubscribers = [];

function subscribeTokenRefresh(callback) {
  refreshSubscribers.push(callback);
}

function onTokenRefreshed(token) {
  refreshSubscribers.forEach((callback) => callback(token));
  refreshSubscribers = [];
}

export function getAccessToken() {
  return localStorage.getItem(ACCESS_TOKEN_KEY);
}

export function getRefreshToken() {
  return localStorage.getItem(REFRESH_TOKEN_KEY);
}

export function getStoredUser() {
  const raw = localStorage.getItem(USER_KEY);
  return raw ? JSON.parse(raw) : null;
}

export function setAuthData({ access, refresh, user }) {
  localStorage.setItem(ACCESS_TOKEN_KEY, access);
  localStorage.setItem(REFRESH_TOKEN_KEY, refresh);
  localStorage.setItem(USER_KEY, JSON.stringify(user));
}

export function clearAuthData() {
  localStorage.removeItem(ACCESS_TOKEN_KEY);
  localStorage.removeItem(REFRESH_TOKEN_KEY);
  localStorage.removeItem(USER_KEY);
}

export function mapBackendRole(role) {
  return role === 'admin' ? 'admin' : 'agent';
}

export function mapApiError(error) {
  if (!error.response) {
    return 'Network error. Please check your connection and try again.';
  }

  const { status, data } = error.response;

  if (typeof data === 'string') {
    return data;
  }

  if (data?.detail) {
    return data.detail;
  }

  if (typeof data === 'object' && data !== null) {
    const messages = [];
    Object.entries(data).forEach(([field, value]) => {
      const label = field === 'non_field_errors' ? '' : `${field}: `;
      if (Array.isArray(value)) {
        messages.push(`${label}${value.join(', ')}`);
      } else if (typeof value === 'string') {
        messages.push(`${label}${value}`);
      }
    });
    if (messages.length > 0) {
      return messages.join(' ');
    }
  }

  const defaults = {
    400: 'Invalid request. Please check your input.',
    401: 'Invalid credentials or session expired.',
    403: 'You do not have permission to perform this action.',
    404: 'The requested resource was not found.',
    500: 'Server error. Please try again later.',
  };

  return defaults[status] || 'Something went wrong. Please try again.';
}

function emptyAddress(type) {
  return {
    id: '',
    type,
    houseOrBuildingName: '',
    landmark: '',
    village: '',
    taluk: '',
    district: '',
    state: '',
    pinCode: '',
    latitude: null,
    longitude: null,
    mapUrl: '',
  };
}

export function mapAddressFromApi(address, type) {
  if (!address) {
    return emptyAddress(type);
  }

  const houseOrBuildingName = [address.house_name, address.building_name]
    .filter(Boolean)
    .join(', ');

  return {
    id: String(address.id),
    type,
    houseOrBuildingName,
    landmark: address.landmark || '',
    village: address.village || '',
    taluk: address.taluk || '',
    district: address.district || '',
    state: address.state || '',
    pinCode: address.pincode || '',
    latitude: address.latitude != null ? Number(address.latitude) : null,
    longitude: address.longitude != null ? Number(address.longitude) : null,
    mapUrl: address.google_maps_link || '',
  };
}

export function mapCustomerFromApi(customer) {
  return {
    id: String(customer.id),
    customerId: customer.customer_id,
    name: customer.full_name,
    primaryMobile: customer.mobile_number,
    alternateMobile: customer.alternate_number || '',
    email: customer.email || '',
    homeAddress: mapAddressFromApi(customer.home_address, 'home'),
    workAddress: customer.work_address
      ? mapAddressFromApi(customer.work_address, 'work')
      : undefined,
    photos: [],
    createdBy: String(customer.created_by),
    createdAt: customer.created_at,
    updatedAt: customer.created_at,
  };
}

export function mapChitPlanFromApi(plan) {
  return {
    id: String(plan.id),
    planName: plan.chit_name,
    planCode: plan.plan_code,
    totalAmount: Number(plan.total_amount),
    numberOfInstallments: plan.number_of_installments,
    monthlyPayment: Number(plan.monthly_payment),
    isActive: plan.is_active,
    createdAt: plan.created_at,
  };
}

export function mapSubscriptionFromApi(subscription) {
  const statusMap = {
    cancelled: 'paused',
    suspended: 'paused',
  };

  return {
    id: String(subscription.id),
    customerId: String(subscription.customer),
    customerName: subscription.customer_name || subscription.customer_id_display || '',
    chitPlanId: String(subscription.chit_plan),
    chitPlanName: subscription.chit_plan_name || subscription.chit_plan_code || '',
    joinedDate: subscription.joined_date,
    status: statusMap[subscription.subscription_status] || subscription.subscription_status,
    paymentStatus: subscription.payment_status,
    totalPaid: 0,
    remainingAmount: 0,
  };
}

export function mapAddressToApi(address, type) {
  const payload = {
    landmark: address.landmark || '',
    village: address.village || '',
    taluk: address.taluk || '',
    district: address.district || '',
    state: address.state || '',
    pincode: address.pinCode || '',
  };

  if (address.latitude != null) {
    payload.latitude = address.latitude;
  }
  if (address.longitude != null) {
    payload.longitude = address.longitude;
  }

  if (type === 'home') {
    payload.house_name = address.houseOrBuildingName || '';
    payload.building_name = '';
  } else {
    payload.building_name = address.houseOrBuildingName || '';
    payload.house_name = '';
  }

  return payload;
}

function dataUrlToFile(dataUrl, filename) {
  if (!dataUrl || !dataUrl.startsWith('data:')) {
    return null;
  }

  const [header, base64] = dataUrl.split(',');
  const mime = header.match(/:(.*?);/)?.[1] || 'image/jpeg';
  const binary = atob(base64);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i += 1) {
    bytes[i] = binary.charCodeAt(i);
  }
  return new File([bytes], filename, { type: mime });
}

async function createAddress(endpoint, customerId, address, type, photoDataUrl) {
  const file = dataUrlToFile(photoDataUrl, `${type}-address.jpg`);
  const payload = {
    customer: customerId,
    ...mapAddressToApi(address, type),
  };

  if (file) {
    const formData = new FormData();
    Object.entries(payload).forEach(([key, value]) => {
      if (value !== '' && value != null) {
        formData.append(key, value);
      }
    });
    formData.append('address_photo', file);
    await api.post(endpoint, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return;
  }

  await api.post(endpoint, payload);
}

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

api.interceptors.request.use((config) => {
  const token = getAccessToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

api.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;

    if (
      error.response?.status === 401 &&
      originalRequest &&
      !originalRequest._retry &&
      !originalRequest.url?.includes('token/')
    ) {
      const refreshToken = getRefreshToken();
      if (!refreshToken) {
        clearAuthData();
        window.location.href = '/login';
        return Promise.reject(error);
      }

      if (isRefreshing) {
        return new Promise((resolve) => {
          subscribeTokenRefresh((token) => {
            originalRequest.headers.Authorization = `Bearer ${token}`;
            resolve(api(originalRequest));
          });
        });
      }

      originalRequest._retry = true;
      isRefreshing = true;

      try {
        const response = await axios.post(`${API_BASE_URL}token/refresh/`, {
          refresh: refreshToken,
        });
        const newAccess = response.data.access;
        localStorage.setItem(ACCESS_TOKEN_KEY, newAccess);
        onTokenRefreshed(newAccess);
        originalRequest.headers.Authorization = `Bearer ${newAccess}`;
        return api(originalRequest);
      } catch (refreshError) {
        clearAuthData();
        window.location.href = '/login';
        return Promise.reject(refreshError);
      } finally {
        isRefreshing = false;
      }
    }

    return Promise.reject(error);
  },
);

export async function login(username, password) {
  const response = await api.post('token/', { username, password });
  const { access, refresh, employee_id, role, role_display } = response.data;

  const user = {
    id: employee_id,
    username,
    email: '',
    role: mapBackendRole(role),
    name: role_display || username,
    employeeId: employee_id,
    isActive: true,
    createdAt: new Date().toISOString(),
  };

  setAuthData({ access, refresh, user });
  return user;
}

export async function fetchCustomers(params = {}) {
  const response = await api.get('customers/', { params });
  const items = Array.isArray(response.data) ? response.data : response.data.results || [];
  return items.map(mapCustomerFromApi);
}

export async function fetchCustomer(id) {
  const response = await api.get(`customers/${id}/`);
  return mapCustomerFromApi(response.data);
}

export async function createCustomerWithDetails({
  customer,
  homeAddress,
  workAddress,
  photos = {},
  subscription,
}) {
  const customerResponse = await api.post('customers/', {
    full_name: customer.name,
    mobile_number: customer.primaryMobile,
    alternate_number: customer.alternateMobile || '',
    email: customer.email || '',
  });

  const createdCustomer = customerResponse.data;

  await createAddress(
    'home-addresses/',
    createdCustomer.id,
    homeAddress,
    'home',
    photos.addressProof,
  );

  if (workAddress) {
    await createAddress(
      'work-addresses/',
      createdCustomer.id,
      workAddress,
      'work',
      photos.workLocation,
    );
  }

  if (subscription?.chitPlanId) {
    await api.post('subscriptions/', {
      customer: createdCustomer.id,
      chit_plan: Number(subscription.chitPlanId),
      joined_date: subscription.joinedDate || new Date().toISOString().split('T')[0],
    });
  }

  return mapCustomerFromApi(
    (await api.get(`customers/${createdCustomer.id}/`)).data,
  );
}

export async function updateCustomer(id, customer) {
  const response = await api.patch(`customers/${id}/`, {
    full_name: customer.name,
    mobile_number: customer.primaryMobile,
    alternate_number: customer.alternateMobile || '',
    email: customer.email || '',
  });
  return mapCustomerFromApi(response.data);
}

export async function deleteCustomer(id) {
  await api.delete(`customers/${id}/`);
}

export async function fetchChitPlans(params = {}) {
  const response = await api.get('chit-plans/', { params });
  const items = Array.isArray(response.data) ? response.data : response.data.results || [];
  return items.map(mapChitPlanFromApi);
}

export async function createChitPlan(plan) {
  const response = await api.post('chit-plans/', {
    plan_code: plan.planCode,
    chit_name: plan.planName,
    total_amount: plan.totalAmount,
    number_of_installments: plan.numberOfInstallments,
    monthly_payment: plan.monthlyPayment,
    is_active: true,
  });
  return mapChitPlanFromApi(response.data);
}

export async function updateChitPlan(id, plan) {
  const response = await api.patch(`chit-plans/${id}/`, {
    plan_code: plan.planCode,
    chit_name: plan.planName,
    total_amount: plan.totalAmount,
    number_of_installments: plan.numberOfInstallments,
    monthly_payment: plan.monthlyPayment,
    is_active: plan.isActive,
  });
  return mapChitPlanFromApi(response.data);
}

export async function toggleChitPlanActive(id, isActive) {
  const response = await api.patch(`chit-plans/${id}/`, { is_active: isActive });
  return mapChitPlanFromApi(response.data);
}

export async function fetchSubscriptions(params = {}) {
  const response = await api.get('subscriptions/', { params });
  const items = Array.isArray(response.data) ? response.data : response.data.results || [];
  return items.map(mapSubscriptionFromApi);
}

export function mapDashboardStatsFromApi(data) {
  return {
    totalCustomers: data.total_customers,
    activeChitties: data.active_subscriptions,
    monthlyCollections: Number(data.monthly_collections_total),
    pendingPayments: data.pending_payments,
    activePlans: data.active_chit_plans,
    recentOnboardings: data.recent_onboardings ?? 0,
  };
}

export async function fetchDashboardStats() {
  const response = await api.get('dashboard/stats/');
  return mapDashboardStatsFromApi(response.data);
}

export function mapDashboardRecentCustomerFromApi(customer) {
  return {
    id: String(customer.id),
    customerId: customer.customer_id,
    name: customer.full_name,
    createdAt: customer.created_at,
  };
}

export async function fetchDashboardRecentCustomers() {
  const response = await api.get('dashboard/recent-customers/');
  const items = Array.isArray(response.data) ? response.data : response.data.results || [];
  return items.map(mapDashboardRecentCustomerFromApi);
}

export function mapDashboardRecentSubscriptionFromApi(subscription) {
  return {
    id: String(subscription.id),
    customerName: subscription.customer_name,
    chitPlanName: subscription.chit_plan_name,
    monthlyPayment: Number(subscription.monthly_payment),
    paymentStatus: subscription.payment_status,
  };
}

export async function fetchDashboardRecentSubscriptions() {
  const response = await api.get('dashboard/recent-subscriptions/');
  const items = Array.isArray(response.data) ? response.data : response.data.results || [];
  return items.map(mapDashboardRecentSubscriptionFromApi);
}

export async function createSubscription({ customerId, chitPlanId, joinedDate }) {
  const response = await api.post('subscriptions/', {
    customer: Number(customerId),
    chit_plan: Number(chitPlanId),
    joined_date: joinedDate,
  });
  return mapSubscriptionFromApi(response.data);
}

export default api;

```

----------------------------------------

### File: src\types\index.ts
```ts
export type UserRole = 'admin' | 'agent';

export interface User {
  id: string;
  username: string;
  email: string;
  role: UserRole;
  name: string;
  employeeId?: string;
  phone?: string;
  isActive: boolean;
  createdAt: string;
}

export interface Address {
  id: string;
  type: 'home' | 'work';
  houseOrBuildingName: string;
  landmark: string;
  village: string;
  taluk: string;
  district: string;
  state: string;
  pinCode: string;
  latitude: number | null;
  longitude: number | null;
  mapUrl: string;
}

export interface CustomerPhoto {
  id: string;
  type: 'customer' | 'address_proof' | 'id_proof' | 'work_location';
  url: string;
  uploadedAt: string;
}

export interface Customer {
  id: string;
  customerId: string;
  name: string;
  primaryMobile: string;
  alternateMobile?: string;
  email: string;
  homeAddress: Address;
  workAddress?: Address;
  photos: CustomerPhoto[];
  createdBy: string;
  createdAt: string;
  updatedAt: string;
}

export interface ChitPlan {
  id: string;
  planName: string;
  planCode: string;
  totalAmount: number;
  numberOfInstallments: number;
  monthlyPayment: number;
  isActive: boolean;
  createdAt: string;
}

export interface Subscription {
  id: string;
  customerId: string;
  customerName: string;
  chitPlanId: string;
  chitPlanName: string;
  joinedDate: string;
  status: 'active' | 'completed' | 'paused';
  paymentStatus: 'paid' | 'pending' | 'overdue';
  totalPaid: number;
  remainingAmount: number;
}

export interface Employee {
  id: string;
  employeeId: string;
  userId: string;
  username: string;
  name: string;
  email: string;
  phone: string;
  role: UserRole;
  isActive: boolean;
  customersCount: number;
  createdAt: string;
}

export interface DashboardStats {
  totalCustomers: number;
  activeChitties: number;
  monthlyCollections: number;
  pendingPayments: number;
  activePlans: number;
  recentOnboardings: number;
}

export interface DashboardRecentCustomer {
  id: string;
  customerId: string;
  name: string;
  createdAt: string;
}

export interface DashboardRecentSubscription {
  id: string;
  customerName: string;
  chitPlanName: string;
  monthlyPayment: number;
  paymentStatus: string;
}

```

----------------------------------------
