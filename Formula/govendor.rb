class Govendor < Formula
  desc "Tool for vendoring Go dependencies"
  homepage "https://github.com/kardianos/govendor"
  url "https://github.com/kardianos/govendor/archive/v1.0.9.tar.gz"
  sha256 "d303abf194838792234a1451c3a1e87885d1b2cd21774867b592c1f7db00551e"
  license "BSD-3-Clause"
  head "https://github.com/kardianos/govendor.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "80a65c6a119d2b511cbbccc810db50822ebdf9f70ef1e46c5e6c17e2a1081ef3" => :big_sur
    sha256 "654e979f975c3cf1174f6b1b572657d4d4d813551e0d4cf73239a2b6e2bc15e4" => :catalina
    sha256 "913ae29b2c13520f049c1cca03f0a12b7aba75702fdb9c981395d3e888903ed3" => :mojave
    sha256 "bf52da036c6701f20182ce7252e7920e4e12630f7e0bf0e3e3d3c9c88d58be8b" => :high_sierra
  end

  deprecate! because: :repo_archived

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"

    (buildpath/"src/github.com/kardianos/").mkpath
    ln_sf buildpath, buildpath/"src/github.com/kardianos/govendor"
    system "go", "build", "-o", bin/"govendor"
  end

  test do
    # Default HOMEBREW_TEMP is /tmp, which is actually a symlink to /private/tmp.
    # `govendor` bails without `.realpath` as it expects $GOPATH to be "real" path.
    ENV["GOPATH"] = testpath.realpath
    commit = "89d9e62992539701a49a19c52ebb33e84cbbe80f"
    (testpath/"src/github.com/project/testing").mkpath

    cd "src/github.com/project/testing" do
      system bin/"govendor", "init"
      assert_predicate Pathname.pwd/"vendor", :exist?, "Failed to init!"
      system bin/"govendor", "fetch", "-tree", "golang.org/x/crypto@#{commit}"
      assert_match commit, File.read("vendor/vendor.json")
      assert_match "golang.org/x/crypto/blowfish", shell_output("#{bin}/govendor list")
    end
  end
end
