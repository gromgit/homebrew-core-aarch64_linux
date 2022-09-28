class Gimme < Formula
  desc "Shell script to install any Go version"
  homepage "https://github.com/travis-ci/gimme"
  url "https://github.com/travis-ci/gimme/archive/v1.5.5.tar.gz"
  sha256 "7854c3f90c2274e14041138f53c9c0bf671be86e49dfb4a61b024270a514fb40"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gimme"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9485cae307f09938d1e5d045c12f44bf3087f7eed5b0eb3cd331c8f4ea8f3579"
  end

  def install
    bin.install "gimme"
  end

  test do
    system "#{bin}/gimme", "-l"
  end
end
