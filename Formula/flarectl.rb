class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.48.0.tar.gz"
  sha256 "030a1cf4ca292b32ed34536294fcbb98a258a140da0a6d91c8c933ded4852547"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a4c8c6a35c836559e0a71218ca3dd9dd607ed9a4698f77f9a437cfb2e510977"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fad193733d928cb67fb2827ddbc05a9eb10acabef7ac1f4e4e55eec7d3742ced"
    sha256 cellar: :any_skip_relocation, monterey:       "14e5d9b947106f6c46229962faffdb721847b82bdd9fffa1282a6f768896ba31"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f1f7e136329414c042edc71be3d8924577e7316ae15e6f67ed9bdec21494d39"
    sha256 cellar: :any_skip_relocation, catalina:       "afaaa14f00384a80d3212ef39c797655e166da68a41c72bba9d9ca66236b752d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89cd4fa59b6f7ef277ffcac3bd45751e9eec91d2ef4f59763376bd0c96732dee"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
