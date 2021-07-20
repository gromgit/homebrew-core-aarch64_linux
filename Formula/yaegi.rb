class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.21.tar.gz"
  sha256 "96c08b7e24babe22098937efa78b0d9fd1f926ea42648b3096c286478cab3629"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b53bc987317d77d0e9d0e8a8bda47dbb2c5b9bbf281ca0bc7f163b6ef4fcc7d"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3311bd01750e552635d3287108897d21241d9851b58dfafa02cc5f14f911e16"
    sha256 cellar: :any_skip_relocation, catalina:      "02f64a4e556a4f741fc584c20753211b36ba288917f7c5a5219abb73b49c551c"
    sha256 cellar: :any_skip_relocation, mojave:        "edd4c4e43ab48c332affab25e7a6220907b94bdefc6ae99d3e295ddfd9a9e765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9777ce234686c2f151971ab1d50c664f529190b3625b48ad953965823983fe75"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
