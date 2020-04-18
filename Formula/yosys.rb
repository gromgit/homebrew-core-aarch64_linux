class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.9.tar.gz"
  sha256 "f2e31371f9cf1b36cb4f57b23fd6eb849adc7d935dcf49f3c905aa5136382c2f"
  revision 1
  head "https://github.com/YosysHQ/yosys.git"

  bottle do
    sha256 "a85ecf7a99c222619a6ab700a9c48e297a40bfb26aa0e7cf3bd62c1f866f7f77" => :catalina
    sha256 "4600fbbe390a05e56acf53bf6c74af99d3cd9504fe5077a35b6aaf6a4e3d134b" => :mojave
    sha256 "bc5262478fddbea5a59542221d7d77d7b4eb679a5938bc5fb72682911870be46" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "python"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system "#{bin}/yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", "#{pkgshare}/adff2dff.v"
  end
end
