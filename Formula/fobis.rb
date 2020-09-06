class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automaticaly building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/53/3a/5533ab0277977027478b4c1285bb20b6beb221b222403b10398fb24e81a2/FoBiS.py-3.0.5.tar.gz"
  sha256 "ef23fde4199277abc693d539a81e0728571c349174da6b7476579f82482ab96c"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d782b47781f9cf87fb130fbd992161fff4cc8ecd3af5b58a75de9f6b79f3e31d" => :catalina
    sha256 "53b1c238046e6a29be31b9ce3628cc045ea34c8c5c5168f64da74557addea5e6" => :mojave
    sha256 "22119f11db9b1e3759b00fb9ca8516764c3f0e2fdd56549ac2f8f8a7b0a0e25f" => :high_sierra
  end

  depends_on "gcc" # for gfortran
  depends_on "graphviz"
  depends_on "python@3.8"

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/e5/7c/d4ccbcde76b4eea8cbd73b67b88c72578e8b4944d1270021596e80b13deb/configparser-5.0.0.tar.gz"
    sha256 "2ca44140ee259b5e3d8aaf47c79c36a7ab0d5e94d70bd4105c03ede7a20ea5a1"
  end

  resource "FoBiS.py" do
    url "https://files.pythonhosted.org/packages/53/3a/5533ab0277977027478b4c1285bb20b6beb221b222403b10398fb24e81a2/FoBiS.py-3.0.5.tar.gz"
    sha256 "ef23fde4199277abc693d539a81e0728571c349174da6b7476579f82482ab96c"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  def install
    virtualenv_install_with_resources
    bin.install libexec/"bin/FoBiS.py"
  end

  test do
    (testpath/"test-mod.f90").write <<~EOS
      module fobis_test_m
        implicit none
        character(*), parameter :: message = "Hello FoBiS"
      end module
    EOS
    (testpath/"test-prog.f90").write <<~EOS
      program fobis_test
        use iso_fortran_env, only: stdout => output_unit
        use fobis_test_m, only: message
        implicit none
        write(stdout,'(A)') message
      end program
    EOS
    system "#{bin}/FoBiS.py", "build", "-compiler", "gnu"
    assert_match /Hello FoBiS/, shell_output(testpath/"test-prog")
  end
end
