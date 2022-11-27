class Iozone < Formula
  desc "File system benchmark tool"
  homepage "https://www.iozone.org/"
  url "https://www.iozone.org/src/current/iozone3_493.tgz"
  sha256 "634c123600b4bb42e827483fa15b2afae6dada2907b784b14e01415933d43198"
  license :cannot_represent

  livecheck do
    url "https://www.iozone.org/src/current/"
    regex(/href=.*?iozone[._-]?v?(\d+(?:[._]\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/iozone"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "57544db6b36b11f919b27a7ac634e56fc865763c5ff0863c18f2b15c42913f0c"
  end

  def install
    cd "src/current" do
      target = OS.mac? ? "macosx" : OS.kernel_name.downcase
      system "make", target, "CC=#{ENV.cc}"
      bin.install "iozone"
      pkgshare.install %w[Generate_Graphs client_list gengnuplot.sh gnu3d.dem
                          gnuplot.dem gnuplotps.dem iozone_visualizer.pl
                          report.pl]
    end
    man1.install "docs/iozone.1"
  end

  test do
    assert_match "File size set to 16384 kB",
      shell_output("#{bin}/iozone -I -s 16M")
  end
end
