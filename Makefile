VERSION=1.0.1
SOURCE=GeoToolkit/Library.fs


all: publish pack push

clean:
	dotnet clean -c Debug
	dotnet clean -c Release
	dotnet clean -c Library


build: build-debug build-release build-library

build-debug: GetToolkit/bin/Debug/netcoreapp3.1/GetToolkit.dll
 
build-release: GetToolkit/bin/Release/netcoreapp3.1/GetToolkit.dll

build-library: GetToolkit/bin/Library/netstandard2.0/GetToolkit.dll


publish: publish-debug publish-release publish-library

publish-debug: GetToolkit/bin/Debug/netcoreapp3.1/publish/GetToolkit.deps.json

publish-release: GetToolkit/bin/Release/netcoreapp3.1/publish/GetToolkit.deps.json

publish-library: GetToolkit/bin/Library/netstandard2.0/publish/GetToolkit.deps.json


pack: pack-debug pack-release pack-library

pack-debug: GetToolkit/bin/Debug/GetToolkit.${VERSION}.nupkg

pack-release: GetToolkit/bin/Release/GetToolkit.${VERSION}.nupkg

pack-library: GetToolkit/bin/Library/GetToolkit.${VERSION}.nupkg


push: .nuget.pushed


GetToolkit/bin/Release/netcoreapp3.1/GetToolkit.dll: ${SOURCE}
	dotnet build -c Release

GetToolkit/bin/Debug/netcoreapp3.1/GetToolkit.dll: ${SOURCE}
	dotnet build -c Debug

GetToolkit/bin/Library/netstandard2.0/GetToolkit.dll: ${SOURCE}
	dotnet build -c Library


GetToolkit/bin/Release/netcoreapp3.1/publish/GetToolkit.deps.json: GetToolkit/bin/Release/netcoreapp3.1/GetToolkit.dll
	dotnet publish -c Release

GetToolkit/bin/Debug/netcoreapp3.1/publish/GetToolkit.deps.json: GetToolkit/bin/Debug/netcoreapp3.1/GetToolkit.dll
	dotnet publish -c Debug

GetToolkit/bin/Library/netstandard2.0/publish/GetToolkit.deps.json: GetToolkit/bin/Library/netstandard2.0/GetToolkit.dll
	dotnet publish -c Library


GetToolkit/bin/Release/GetToolkit.${VERSION}.nupkg: GetToolkit/bin/Release/netcoreapp3.1/GetToolkit.dll
	dotnet pack -c Release --no-build -p:Version=${VERSION}

GetToolkit/bin/Debug/GetToolkit.${VERSION}.nupkg: GetToolkit/bin/Debug/netcoreapp3.1/GetToolkit.dll
	dotnet pack -c Debug --no-build -p:Version=${VERSION}

GetToolkit/bin/Library/GetToolkit.${VERSION}.nupkg: GetToolkit/bin/Library/netstandard2.0/GetToolkit.dll
	dotnet pack -c Library --no-build -p:Version=${VERSION}


.nuget.pushed: GetToolkit/bin/Library/GetToolkit.${VERSION}.nupkg
	dotnet nuget push $< -s GitHub --skip-duplicate
	nuget push $< -Source nuget.org -SkipDuplicate
	touch .nuget.pushed
