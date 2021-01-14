class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.6.3.tar.gz"
  sha256 "f29ce37ed3cd6e8f81895c431fdb356de280807952986bcc54e3eefd3e054cda"
  license "MIT"
  revision 1

  bottle do
    cellar :any
    sha256 "1601a6dfc5828efdba04cea3b825afc120278fd0b46f686fa33d5772c0648a53" => :big_sur
    sha256 "e281e4f074503fca3b8916f29e32904b7594979f18cee69e24630e6fadfd3728" => :catalina
    sha256 "4c697ffa13d9bfe663279c735abe6d0ef70438ce42984974f2add7374c5a3c2e" => :mojave
  end

  depends_on "dotnet"

  def install
    system "dotnet", "build",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet"].version.major_minor}",
           "--output", "out",
           "src/GitVersionExe/GitVersionExe.csproj"

    libexec.install Dir["out/*"]

    (bin/"gitversion").write <<~EOS
      #!/bin/sh
      exec "#{Formula["dotnet"].opt_bin}/dotnet" "#{libexec}/gitversion.dll" "$@"
    EOS
  end

  test do
    # Circumvent GitVersion's build server detection scheme:
    ENV["GITHUB_ACTIONS"] = nil

    (testpath/"test.txt").write("test")
    system "git", "init"
    system "git", "config", "user.name", "Test"
    system "git", "config", "user.email", "test@example.com"
    system "git", "add", "test.txt"
    system "git", "commit", "-q", "--message='Test'"
    assert_match '"FullSemVer": "0.1.0+0"', shell_output("#{bin}/gitversion -output json")
  end
end
