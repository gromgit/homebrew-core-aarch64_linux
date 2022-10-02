class Nq < Formula
  desc "Unix command-line queue utility"
  homepage "https://github.com/leahneukirchen/nq"
  url "https://github.com/leahneukirchen/nq/archive/v0.5.tar.gz"
  sha256 "3f01aaf0b8eee4f5080ed1cd71887cb6485d366257d4cf5470878da2b734b030"
  license "CC0-1.0"
  head "https://github.com/leahneukirchen/nq.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/nq"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f9a934e3618f04e2b654c0632bc79bd5b4667af818711408cc50d9c8d05832fd"
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
