class Pdf2djvu < Formula
  desc "Create DjVu files from PDF files"
  homepage "https://jwilk.net/software/pdf2djvu"
  url "https://github.com/jwilk/pdf2djvu/releases/download/0.9.18.2/pdf2djvu-0.9.18.2.tar.xz"
  sha256 "9ea03f21d841a336808d89d65015713c0785e7295a6559d77771dc795333a9fa"
  license "GPL-2.0-only"
  revision 5
  head "https://github.com/jwilk/pdf2djvu.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "33b723c2bfdb9b47ff081bff8b45252b19b85ecab15a47eb8491e5a2a8078eeb"
    sha256 arm64_big_sur:  "c10abfb31260e88e496cd5d19a3432315a715e612b7374616082aa10b538dac8"
    sha256 monterey:       "4502308ab8f624835571461015fdafea2a826da3484709e4115216d0a29c7d9e"
    sha256 big_sur:        "04bcbe91fbbcead5d8cb4d1e2bf3a0cd6d11baf9e4e24417735df2637663561f"
    sha256 catalina:       "56bf827f6358b019e55d11a4088f57cf2601e06158f424bbec72436ea9fdadcd"
    sha256 x86_64_linux:   "7e3e073492d37b1cecc31a7040da683653bc8b92cf74bac8ae04ae609640714b"
  end

  depends_on "pkg-config" => :build
  depends_on "djvulibre"
  depends_on "exiv2"
  depends_on "gettext"
  depends_on "poppler"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # poppler compiles with GCC

  # poppler 22.04.0 compatibility, remove in next release
  patch do
    url "https://github.com/jwilk/pdf2djvu/commit/e170ad557d5f13daeeac047dfaa79347bbe5062f.patch?full_index=1"
    sha256 "424c4fe330e01d9fbf33eb7bce638ea6d3788e1e1b8b3932364257631c867d8a"
  end

  # poppler 22.04.0 compatibility, remove in next release

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e0c880b/pdf2djvu/main-use-pdf-link-Destination-copy-constructor.patch"
    sha256 "3d1e9fc0d7f2861142721befff9e33b5c2665dacc78ac12b613af7b1e6fb0ce6"
  end

  # poppler 22.04.0 compatibility, remove in next release
  patch do
    url "https://github.com/jwilk/pdf2djvu/commit/956fedc7e0831126b9006efedad5519c14201c52.patch?full_index=1"
    sha256 "4ab8d3ff7f8474b86949d4acf23da6f6ac77303e94feeb849fb3298358efd23f"
  end

  def install
    ENV.append "CXXFLAGS", "-std=gnu++17" # poppler uses std::optional
    ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR=1" if ENV.compiler == :clang
    system "./configure", "--prefix=#{prefix}"
    system "make", "djvulibre_bindir=#{Formula["djvulibre"].opt_bin}"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.pdf"), "test.pdf"
    system "#{bin}/pdf2djvu", "-o", "test.djvu", "test.pdf"
    assert_predicate testpath/"test.djvu", :exist?
  end
end
