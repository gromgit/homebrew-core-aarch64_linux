class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.6.0.tar.gz"
  sha256 "a7101491392309b1549be0394c5e3d368f2dae3fcc351f6f653fe4b33ffd4bee"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/lego"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f6c7df947554f7e481d180ed08ae2decaaed6e6d7f210c270670df52abdd93e8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output("DO_AUTH_TOKEN=xx lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
