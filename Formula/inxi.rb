class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.09-1.tar.gz"
  sha256 "aa263a4a567ec9fc9e3e6ab03b970db2ba9be7ceeda3919107c6f3f66053d5e3"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "597ec8d93426f4d2f97b82c967cfa6c7cf9dfe42b3a339831834f286369c1b92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "597ec8d93426f4d2f97b82c967cfa6c7cf9dfe42b3a339831834f286369c1b92"
    sha256 cellar: :any_skip_relocation, monterey:       "d37ba6b7de09af7970730778275cf412b221663625f4821276491cdae48d30ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "d37ba6b7de09af7970730778275cf412b221663625f4821276491cdae48d30ee"
    sha256 cellar: :any_skip_relocation, catalina:       "d37ba6b7de09af7970730778275cf412b221663625f4821276491cdae48d30ee"
  end

  def install
    bin.install "inxi"
    man1.install "inxi.1"

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install file
    end
  end

  test do
    inxi_output = shell_output("#{bin}/inxi")

    uname = shell_output("uname").strip
    assert_match uname.to_str, inxi_output.to_s

    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
