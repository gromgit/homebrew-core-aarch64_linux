class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.4.5.tar.gz"
  sha256 "8baa83d8d74bf357439fb3219568ef84f148a7bb4da3eb7dc637eac4715c261c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "47228e8e7b5654b1e20b8b8aa9330d0715690cc7789da7c6a53580a7ba6b7406"
    sha256 cellar: :any_skip_relocation, big_sur:       "1dc22c4e80271bb2d16b84d2a00d4940b220d03589f1db8e9972397a5ed102a0"
    sha256 cellar: :any_skip_relocation, catalina:      "01b24492421aecefb97a6250ca54b9e6a54892ee5b2fe0d314b614b27a702a36"
    sha256 cellar: :any_skip_relocation, mojave:        "a94d07360b404dfb08c61944482a9041b57cc9e50d173156d2010ce33ee99c52"
  end

  depends_on "rust" => :build

  def install
    File.delete("Cross.toml")
    remove_dir(".cargo")
    Dir.chdir "geph4-client"
    system "cargo", "install", "--bin", "geph4-client", *std_cargo_args
  end

  test do
    assert_equal "{\"error\":\"wrong password\"}",
     shell_output("#{bin}/geph4-client sync --username 'test' --password 'test' --credential-cache ~/test.db")
       .lines.last.strip
  end
end
