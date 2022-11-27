class Smimesign < Formula
  desc "S/MIME signing utility for use with Git"
  homepage "https://github.com/github/smimesign"
  url "https://github.com/github/smimesign/archive/v0.2.0.tar.gz"
  sha256 "b5921dc3f3b446743e130d1ee39ab9ed2e256b001bd52cf410d30a0eb087f54e"
  license "MIT"

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.versionString=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smimesign --version")
    system "#{bin}/smimesign", "--list-keys"
    assert_match "could not find identity matching specified user-id: bad@identity",
      shell_output("#{bin}/smimesign -su bad@identity 2>&1", 1)
  end
end
