class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.11.2.tar.gz"
  sha256 "33874c81387f03fe1a27c64cb6fb585a458c1a2c1548b4b86694da5f81164355"
  license "Apache-2.0"
  head "https://github.com/shyiko/jabba.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/jabba"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "dd5b84667aae11e6a551d0c9375c203e320aea16cd394165aa10bf4af3b7c9cf"
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/shyiko/jabba"
    dir.install buildpath.children
    cd dir do
      ldflags = "-X main.version=#{version}"
      system "glide", "install"
      system "go", "build", "-ldflags", ldflags, "-o", bin/"jabba"
      prefix.install_metafiles
    end
  end

  test do
    jdk_version = "zulu@1.16.0-0"
    version_check ='openjdk version "16'

    ENV["JABBA_HOME"] = testpath/"jabba_home"

    system bin/"jabba", "install", jdk_version
    jdk_path = shell_output("#{bin}/jabba which #{jdk_version}").strip
    jdk_path += "/Contents/Home" if OS.mac?
    assert_match version_check,
                 shell_output("#{jdk_path}/bin/java -version 2>&1")
  end
end
