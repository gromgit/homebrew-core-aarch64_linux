class Mpssh < Formula
  desc "Mass parallel ssh"
  homepage "https://github.com/ndenev/mpssh"
  license "BSD-3-Clause"
  head "https://github.com/ndenev/mpssh.git", branch: "master"

  stable do
    url "https://github.com/ndenev/mpssh/archive/1.3.3.tar.gz"
    sha256 "510e11c3e177a31c1052c8b4ec06357c147648c86411ac3ed4ac814d0d927f2f"
    patch do
      # don't install binaries as root (upstream commit)
      url "https://github.com/ndenev/mpssh/commit/3cbb868b6fdf8dff9ab86868510c0455ad1ec1b3.patch?full_index=1"
      sha256 "a6c596c87a4945e6a77b779fcc42867033dbfd95e27ede492e8b841738a67316"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mpssh"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c256282e1e26ac846a9f89eba558d00ba37849508dc4523fc62bf01a1c56873b"
  end

  def install
    system "make", "install", "CC=#{ENV.cc}", "BIN=#{bin}"
    man1.install "mpssh.1"
  end

  test do
    system "#{bin}/mpssh"
  end
end
