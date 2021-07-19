class Ns3 < Formula
  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.34/ns-3-dev-ns-3.34.tar.bz2"
  sha256 "a565d46a73ff7de68808535d93884f59a6ed7c9faa94de1248ed4f59fb6d5d3d"
  license "GPL-2.0-only"

  depends_on "boost" => :build
  depends_on "python@3.9" => [:build, :test]

  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  resource "pybindgen" do
    url "https://files.pythonhosted.org/packages/7a/c6/14a9359621000ee5b7d5620af679be23f72c0ed17887b15228327427f97d/PyBindGen-0.22.0.tar.gz"
    sha256 "5b4837d3138ac56863d93fe462f1dac39fb87bd50898e0da4c57fefd645437ac"
  end

  def install
    resource("pybindgen").stage buildpath/"pybindgen"

    system "./waf", "configure", "--prefix=#{prefix}",
                                 "--build-profile=release",
                                 "--disable-gtk",
                                 "--with-python=#{Formula["python@3.9"].opt_bin/"python3"}",
                                 "--with-pybindgen=#{buildpath}/pybindgen"
    system "./waf", "--jobs=#{ENV.make_jobs}"
    system "./waf", "install"

    pkgshare.install "examples/tutorial/first.cc", "examples/tutorial/first.py"
  end

  test do
    system ENV.cxx, pkgshare/"first.cc", "-I#{include}/ns#{version}", "-L#{lib}",
           "-lns#{version}-core", "-lns#{version}-network", "-lns#{version}-internet",
           "-lns#{version}-point-to-point", "-lns#{version}-applications",
           "-std=c++11", "-o", "test"
    system "./test"

    system Formula["python@3.9"].opt_bin/"python3", pkgshare/"first.py"
  end
end
