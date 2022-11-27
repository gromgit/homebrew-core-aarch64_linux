class Devdash < Formula
  desc "Highly Configurable Terminal Dashboard for Developers"
  homepage "https://thedevdash.com"
  url "https://github.com/Phantas0s/devdash/archive/v0.5.0.tar.gz"
  sha256 "633a0a599a230a93b7c4eeacdf79a91a2bb672058ef3d5aacce5121167df8d28"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/devdash"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e0a9e8ac0e6e0be762419de1d5eda2ea456bc40f0610fd770fff2448c67b9d60"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"devdash", "-h"
  end
end
