class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2022/sqlite-src-3390100.zip"
  version "3.39.1"
  sha256 "366c7abbee5dbe8882cd7578a61a6ed3f5d08c5f6de3535a0003125b4646cc57"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "879a6679ed8c7172f5af0f42713e45513ffa8ded68787e2b48f1d390133a6fce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce2dfbd5bed8fd7a6bb233b4f078270f0ce212f0b8258c4d85edee0e8d3a2210"
    sha256 cellar: :any_skip_relocation, monterey:       "bab02812ecf4ebcc2b6e0317a12154f658323631088c8174312d01ab9129d9e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "20c33495b4dd89fa10461a992604f12ad0644478415c540b07e91c9adcac0e06"
    sha256 cellar: :any_skip_relocation, catalina:       "e76a2ff30d88bdf84afc2382ca2cf20046cde7d503f716ce72737b0b3492f1f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78cbf26ff0c7bcd83518be422ef36871bfd38b933d587ccae2aa6db0189e0072"
  end

  uses_from_macos "sqlite" => :test
  uses_from_macos "tcl-tk"

  def install
    tcl = if OS.mac?
      MacOS.sdk_path/"System/Library/Frameworks/Tcl.framework"
    else
      Formula["tcl-tk"].opt_lib
    end

    system "./configure", "--disable-debug",
                          "--with-tcl=#{tcl}",
                          "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS
    system "sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
