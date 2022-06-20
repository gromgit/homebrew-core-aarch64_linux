class Nq < Formula
  desc "Unix command-line queue utility"
  homepage "https://github.com/chneukirchen/nq"
  url "https://github.com/chneukirchen/nq/archive/v0.5.tar.gz"
  sha256 "3f01aaf0b8eee4f5080ed1cd71887cb6485d366257d4cf5470878da2b734b030"
  license "CC0-1.0"
  head "https://github.com/chneukirchen/nq.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/nq"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3313ac1728095e7e4a59c85911866d993e3a3a337353251e89f718966c1b8855"
  end

  def install
    system "make", "all", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/nq", "touch", "TEST"
    assert_match "exited with status 0", shell_output("#{bin}/fq -a")
    assert_predicate testpath/"TEST", :exist?
  end
end
