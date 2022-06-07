class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.1.tar.gz"
  sha256 "319f4e93506e2144edaa280b0185fb37c4374cf7d7468a5e5c8c1b678189250a"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/lxc"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b79686197e10d31bfa0913e763a77d873f2d4f4120dd00db0150e65f9817f0a4"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin

    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
