class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.7.10.tar.gz"
  sha256 "733503055e309e83898a403481d92357fc3b02d4642acdb51026dd2dd44e0477"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "e5cd989ba47336992e1c1eb249be04bad03d2ec31140e31bdc8f8786f76fbc1f"
    sha256 arm64_big_sur:  "c0afa46b0f09a5eb8010af9fa9d4889a7abc368afd8610d5a8ca7278f4a63c29"
    sha256 monterey:       "ae972f11dad4fdf75e1e1851b23c8d1dfe0a3a56011b9cd4a8f2f17882e94cb8"
    sha256 big_sur:        "d282279a5e495bcc519929d9a02d0326ecd1103e205e815e360e01916329444b"
    sha256 catalina:       "ff495b4730f14f39cc4a4348b77483a1a928ee8a3f81b0f54a44376d0e106477"
    sha256 x86_64_linux:   "855105a984378bd97827ebf7bb0b2f6d23bfa78bb8cfb9734d23708af803c389"
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
