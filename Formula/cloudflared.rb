class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2022.5.3.tar.gz"
  sha256 "d5d55a143afb918dad279490bc36e4d3537c2b862cdecfcd5dfe5bb52af63e7e"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eae50037c2ab90deeb711fe45478c1ea10436f025b6d007b6f78c331b497b5f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff960b6fa3245585be8deee9a8225caea65690fa321a9e9f877ab8d8a87e5aab"
    sha256 cellar: :any_skip_relocation, monterey:       "8d62e04f66b7f33aaca81fbcb2d6e421194fbea18731e1a4cbf069c686cfc379"
    sha256 cellar: :any_skip_relocation, big_sur:        "531b61c103cc1b4b8fba87c73d26c33c8904f9de2d55074d6d8e82ac6f245986"
    sha256 cellar: :any_skip_relocation, catalina:       "63df5f4efa03a23c0be83b9e12df7137ccd34396130bc86f91242c2ccd55a3e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dbf0e918e16539c7093f7dbbab02ef3bb8b9495650acf3abb3a8ca24f6ffc70"
  end

  depends_on "go" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  test do
    help_output = shell_output("#{bin}/cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}/cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}/cloudflared tunnel run abcd 2>&1", 1)
    assert_match "cloudflared was installed by #{tap.user}. Please update using the same method.",
      shell_output("#{bin}/cloudflared update 2>&1")
  end
end
