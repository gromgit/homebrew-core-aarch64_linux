class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.20-1.tar.gz"
  sha256 "610b7cd60b1ca3df091c51f3ed80d73b1ed57f4be10007f40dc7487bfb2bb4af"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6d7465cc68039981acdea5a227a46fc4e819f4bf927f27d417aa0c592736fdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6d7465cc68039981acdea5a227a46fc4e819f4bf927f27d417aa0c592736fdf"
    sha256 cellar: :any_skip_relocation, monterey:       "17f0e402a6db124b8642978c0dc9495383e25d114088a90ab0f5620d01488722"
    sha256 cellar: :any_skip_relocation, big_sur:        "17f0e402a6db124b8642978c0dc9495383e25d114088a90ab0f5620d01488722"
    sha256 cellar: :any_skip_relocation, catalina:       "17f0e402a6db124b8642978c0dc9495383e25d114088a90ab0f5620d01488722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6d7465cc68039981acdea5a227a46fc4e819f4bf927f27d417aa0c592736fdf"
  end

  uses_from_macos "perl"

  def install
    bin.install "inxi"
    man1.install "inxi.1"

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install file
    end
  end

  test do
    inxi_output = shell_output("#{bin}/inxi")
    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
