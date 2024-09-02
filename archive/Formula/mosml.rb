class Mosml < Formula
  desc "Moscow ML"
  homepage "https://mosml.org/"
  url "https://github.com/kfl/mosml/archive/ver-2.10.1.tar.gz"
  sha256 "fed5393668b88d69475b070999b1fd34e902591345de7f09b236824b92e4a78f"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mosml"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "45c65469e754da9821aea150ae768baec3d0497b607d87c52219e0d54084638f"
  end

  depends_on "gmp"

  def install
    cd "src" do
      system "make", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "world"
      system "make", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "install"
    end
  end

  test do
    require "pty"

    _, w, = PTY.spawn bin/"mosml"
    w.write "quit();\n"

    assert_equal "I don't know what to do with file \"foo\", ignored", shell_output("#{bin}/mosmlc foo 2>&1").strip
  end
end
