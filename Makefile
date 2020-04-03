VERSION=1.0.30
SOURCE=GeoToolkit/Library.fs


all: publish pack push

clean:
	dotnet clean -c Debug -f netcoreapp3.1
	dotnet clean -c Release -f netcoreapp3.1
	dotnet clean -c Library -f netcoreapp3.1
	dotnet clean -c Debug -f netstandard2.0
	dotnet clean -c Release -f netstandard2.0
	dotnet clean -c Library -f netstandard2.0


build: build-debug build-release build-library

build-debug: GeoToolkit/bin/Debug/netcoreapp3.1/GeoToolkit.dll
 
build-release: GeoToolkit/bin/Release/netcoreapp3.1/GeoToolkit.dll

build-library: GeoToolkit/bin/Library/netstandard2.0/GeoToolkit.dll


publish: publish-debug publish-release publish-library

publish-debug: GeoToolkit/bin/Debug/netcoreapp3.1/publish/GeoToolkit.deps.json

publish-release: GeoToolkit/bin/Release/netcoreapp3.1/publish/GeoToolkit.deps.json

publish-library: GeoToolkit/bin/Library/netstandard2.0/publish/GeoToolkit.deps.json


pack: pack-debug pack-release pack-library

pack-debug: GeoToolkit/bin/Debug/ShowingCloud.GIS.GeoToolkit.${VERSION}.nupkg

pack-release: GeoToolkit/bin/Release/ShowingCloud.GIS.GeoToolkit.${VERSION}.nupkg

pack-library: GeoToolkit/bin/Library/ShowingCloud.GIS.GeoToolkit.${VERSION}.nupkg


push: .nuget.pushed


GeoToolkit/bin/Release/netcoreapp3.1/GeoToolkit.dll: ${SOURCE}
	dotnet build -c Release -f netcoreapp3.1

GeoToolkit/bin/Debug/netcoreapp3.1/GeoToolkit.dll: ${SOURCE}
	dotnet build -c Debug -f netcoreapp3.1

GeoToolkit/bin/Library/netstandard2.0/GeoToolkit.dll: ${SOURCE}
	dotnet build -c Library -f netstandard2.0


GeoToolkit/bin/Release/netcoreapp3.1/publish/GeoToolkit.deps.json: GeoToolkit/bin/Release/netcoreapp3.1/GeoToolkit.dll
	dotnet publish -c Release -f netcoreapp3.1

GeoToolkit/bin/Debug/netcoreapp3.1/publish/GeoToolkit.deps.json: GeoToolkit/bin/Debug/netcoreapp3.1/GeoToolkit.dll
	dotnet publish -c Debug -f netcoreapp3.1

GeoToolkit/bin/Library/netstandard2.0/publish/GeoToolkit.deps.json: GeoToolkit/bin/Library/netstandard2.0/GeoToolkit.dll
	dotnet publish -c Library -f netstandard2.0


GeoToolkit/bin/Release/ShowingCloud.GIS.GeoToolkit.${VERSION}.nupkg: GeoToolkit/bin/Release/netcoreapp3.1/GeoToolkit.dll
	dotnet pack -c Release --no-build -p:Version=${VERSION} -p:TargetFrameworks=netcoreapp3.1

GeoToolkit/bin/Debug/ShowingCloud.GIS.GeoToolkit.${VERSION}.nupkg: GeoToolkit/bin/Debug/netcoreapp3.1/GeoToolkit.dll
	dotnet pack -c Debug --no-build -p:Version=${VERSION} -p:TargetFrameworks=netcoreapp3.1

GeoToolkit/bin/Library/ShowingCloud.GIS.GeoToolkit.${VERSION}.nupkg: GeoToolkit/bin/Library/netstandard2.0/GeoToolkit.dll
	dotnet pack -c Library --no-build -p:Version=${VERSION} -p:TargetFrameworks=netstandard2.0


.nuget.pushed: GeoToolkit/bin/Library/ShowingCloud.GIS.GeoToolkit.${VERSION}.nupkg
	dotnet nuget push $< -s GitHub --skip-duplicate
	nuget push $< -Source nuget.org -SkipDuplicate
	touch .nuget.pushed
