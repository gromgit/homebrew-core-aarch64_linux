class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2022/sqlite-src-3380300.zip"
  version "3.38.3"
  sha256 "a104d493e084006bd74ff1ff7ac2eb2b387c7c0a3b63ba6fea2fafb4118313af"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f507929ad56d01aa2ed6e099ef405436377578798986ee0dc43cc04bd70c6c7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "076f3e0132c1b3bfaa2898dbbeeb40fbfa78dadb011c84da967d68fde3546288"
    sha256 cellar: :any_skip_relocation, monterey:       "8b0b64c43f754db7b103030e4d4be3a2169608f6cfbbb7524280f71c709b366d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5819df10a03ff08364a8142b99100552d5b925f32454a1eb0dcb63522953379c"
    sha256 cellar: :any_skip_relocation, catalina:       "3287523c0bbcfc5571ebc289786343a27761a7b1e82441b4466c71904166b5d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f4efb006f4e6d4774b41b0ade6672b53e634a9dff29f7acc941b37394c7e6f4"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end
