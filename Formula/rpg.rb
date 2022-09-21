class Rpg < Formula
  desc "Ruby package management for UNIX"
  homepage "https://github.com/rtomayko/rpg"
  url "https://github.com/downloads/rtomayko/rpg/rpg-0.3.0.tar.gz"
  sha256 "c350f64744fb602956a91a57c8920e69058ea42e4e36b0e74368e96954d9d0c7"
  license "MIT"
  head "https://github.com/rtomayko/rpg.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rpg"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "24e1ca4e723408127ac9032dcb7098d6154790c54de410e6e433807513056205"
  end

  deprecate! date: "2017-11-08", because: :repo_archived

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/rpg", "config"
  end
end
