class Urh < Formula
  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/48/c0/262368bb3adab8a44d93e6ffe57c41081c28ae86cf72e2f06bc6ff43050a/urh-2.9.0.tar.gz"
  sha256 "4fa5f6b846ed01697d944dd357598103bdfbda67221fb6912a7d6f7822c466ac"
  license "GPL-3.0"
  head "https://github.com/jopohl/urh.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "c9fa3d81ff9659b9e530676a4772fd757e9cd0318bd0455fa544745285b07319" => :big_sur
    sha256 "f068fa135004bcf4b6c0cbfee87a542b65c85de90aab9f2bc104f969de63a66c" => :catalina
    sha256 "6d2c9dc81e4713c7fed35a7bb045d6c60428381567b162b3c20edb4eebb585fb" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "cython"
  depends_on "hackrf"
  depends_on "numpy"
  depends_on "pyqt"
  depends_on "python@3.9"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/33/e0/82d459af36bda999f82c7ea86c67610591cf5556168f48fd6509e5fa154d/psutil-5.7.3.tar.gz"
    sha256 "af73f7bcebdc538eda9cc81d19db1db7bf26f103f91081d780bbacfcb620dee2"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    (testpath/"test.py").write <<~EOS
      from urh.util.GenericCRC import GenericCRC;
      c = GenericCRC();
      expected = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0]
      assert(expected == c.crc([0, 1, 0, 1, 1, 0, 1, 0]).tolist())
    EOS
    system Formula["python@3.9"].opt_bin/"python3", "test.py"

    # test command-line functionality
    output = shell_output("#{bin}/urh_cli -pm 0 0 -pm 1 100 -mo ASK -sps 100 -s 2e3 " \
                          "-m 1010111100001 -f 868.3e6 -d RTL-TCP -tx 2>/dev/null", 1)

    assert_match(/Modulating/, output)
    assert_match(/Successfully modulated 1 messages/, output)
  end
end
