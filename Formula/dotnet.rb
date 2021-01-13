class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  url "https://github.com/dotnet/source-build.git",
      tag:      "v5.0.100-SDK",
      revision: "67f4df5115c23264eb7193cc623d1fa1050a3cc2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)-SDK$/i)
  end

  bottle do
    cellar :any
    sha256 "90d24b7d83bd2d5da82148beca9c4ae758402226b848f2caf98093c7c4d073f8" => :catalina
    sha256 "952fab6c217409f77da328251a234e3486feba52427459da06ea7f1f8a7bb91f" => :mojave
    sha256 "41fd78bd40cff8931aa9d059bed8bc9575270a1ef32ef854e1911b069d6c8a6c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on "curl"
  depends_on "icu4c"
  depends_on "openssl@1.1"

  # Replace legacy MyGet feeds
  # https://github.com/dotnet/source-build/pull/1972
  patch do
    url "https://github.com/dotnet/source-build/commit/eea00e5feef14010533a60ab240f54f12e2c5764.patch?full_index=1"
    sha256 "76d9b638200d3d2712d8a3380f68a0c12f370ff21881631567f2704788636c47"
  end

  # Fix the find command used for logger
  # Use TargetOverrideRid (osx-x64) instead of TargetRid (osx.10.13-x64)
  # https://github.com/dotnet/source-build/pull/1962
  patch :DATA

  def install
    # Arguments needed to not artificially time-limit downloads from Azure.
    # See the following GitHub issue comment for details:
    # https://github.com/dotnet/source-build/issues/1596#issuecomment-670995776
    system "./build.sh", "/p:DownloadSourceBuildReferencePackagesTimeoutSeconds=N/A",
                         "/p:DownloadSourceBuiltArtifactsTimeoutSeconds=N/A"

    libexec.mkpath
    tarball = Dir["artifacts/*/Release/dotnet-sdk-#{version}-*.tar.gz"].first
    system "tar", "-xzf", tarball, "--directory", libexec
    doc.install Dir[libexec/"*.txt"]
    (bin/"dotnet").write_env_script libexec/"dotnet", DOTNET_ROOT: libexec
  end

  test do
    target_framework = "net#{version.major_minor}"
    (testpath/"test.cs").write <<~EOS
      using System;

      namespace Homebrew
      {
        public class Dotnet
        {
          public static void Main(string[] args)
          {
            var joined = String.Join(",", args);
            Console.WriteLine(joined);
          }
        }
      }
    EOS
    (testpath/"test.csproj").write <<~EOS
      <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
          <OutputType>Exe</OutputType>
          <TargetFrameworks>#{target_framework}</TargetFrameworks>
          <PlatformTarget>AnyCPU</PlatformTarget>
          <RootNamespace>Homebrew</RootNamespace>
          <PackageId>Homebrew.Dotnet</PackageId>
          <Title>Homebrew.Dotnet</Title>
          <Product>$(AssemblyName)</Product>
          <EnableDefaultCompileItems>false</EnableDefaultCompileItems>
        </PropertyGroup>
        <ItemGroup>
          <Compile Include="test.cs" />
        </ItemGroup>
      </Project>
    EOS
    system bin/"dotnet", "build", "--framework", target_framework, "--output", testpath, testpath/"test.csproj"
    assert_equal "#{testpath}/test.dll,a,b,c\n",
                 shell_output("#{bin}/dotnet run --framework #{target_framework} #{testpath}/test.dll a b c")
  end
end
__END__
diff --git a/repos/Directory.Build.targets b/repos/Directory.Build.targets
index 1aafae1ef4e9f9fc5b8cb1dedca940a038545c8a..91b00d04598c979ba2ab042d23f645c6fc97062e 100644
--- a/repos/Directory.Build.targets
+++ b/repos/Directory.Build.targets
@@ -97,7 +97,7 @@
          See https://github.com/dotnet/source-build/issues/1914 for details. -->
     <ReplaceTextInFile InputFile="$(EngCommonToolsShFile)"
                        OldText="local logger_path=&quot;$toolset_dir/$_InitializeBuildToolFramework/Microsoft.DotNet.Arcade.Sdk.dll&quot;"
-                       NewText="logger_path=&quot;%24toolset_dir&quot;/%24%28cd &quot;$toolset_dir&quot; &amp;&amp; find -name Microsoft.DotNet.Arcade.Sdk.dll -regex &apos;.*netcoreapp2.1.*\|.*net5.0.*&apos;)" />
+                       NewText="logger_path=&quot;%24toolset_dir&quot;/%24%28cd &quot;$toolset_dir&quot; &amp;&amp; find . -name Microsoft.DotNet.Arcade.Sdk.dll \( -regex &apos;.*netcoreapp2.1.*&apos; -or -regex &apos;.*net5.0.*&apos; \) )" />
 
     <WriteLinesToFile File="$(RepoCompletedSemaphorePath)UpdateBuildToolFramework.complete" Overwrite="true" />
   </Target>
diff --git a/repos/runtime.proj b/repos/runtime.proj
index 6cb3e80ab1808704973ee1ef6a7f2f5171752877..74d9064f711f3cbb8ec02fd392113766d4603884 100644
--- a/repos/runtime.proj
+++ b/repos/runtime.proj
@@ -15,7 +15,7 @@
     <!-- Additional Targets -->
   <Target Name="InstallJustBuiltRuntime" AfterTargets="RemoveBuiltPackagesFromCache">
     <!-- Install the runtime that was just built to be used by downstream repos, namely, aspnetcore -->
-    <Exec Command="tar -xvf $(SourceBuiltAssetsDir)dotnet-runtime-$(runtimeOutputPackageVersion)-$(TargetRid).tar.gz -C $(DotNetRoot)" />
+    <Exec Command="tar -xvf $(SourceBuiltAssetsDir)dotnet-runtime-$(runtimeOutputPackageVersion)-$(OverrideTargetRid).tar.gz -C $(DotNetRoot)" />
   </Target>
 
 
