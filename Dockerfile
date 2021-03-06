FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 5000
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /Kshitiz
COPY ["PersonalWebsite/PersonalWebsite.csproj", "PersonalWebsite/"]
RUN dotnet restore "PersonalWebsite/PersonalWebsite.csproj"
COPY . .
WORKDIR "/Kshitiz/PersonalWebsite"
RUN dotnet build "PersonalWebsite.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PersonalWebsite.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:5000
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PersonalWebsite.dll"]