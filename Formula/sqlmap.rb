class Sqlmap < Formula
  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.5.7.tar.gz"
  sha256 "b5d7bd6bfee2fcce2f84b332a9c337d45c37343c53b5793cc4141db77789db70"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7c950aafdc4ef567cfad3bd7c682dd187ecaaef1f6736ebe583304f1e51fa47e"
    sha256 cellar: :any_skip_relocation, big_sur:       "b871840ee1a99f5c2ea14522302b63fefe0d777703d4ceaad241215939dcc45c"
    sha256 cellar: :any_skip_relocation, catalina:      "b871840ee1a99f5c2ea14522302b63fefe0d777703d4ceaad241215939dcc45c"
    sha256 cellar: :any_skip_relocation, mojave:        "b871840ee1a99f5c2ea14522302b63fefe0d777703d4ceaad241215939dcc45c"
  end

  def install
    libexec.install Dir["*"]

    files = [
      libexec/"lib/core/dicts.py",
      libexec/"lib/core/settings.py",
      libexec/"lib/request/basic.py",
      libexec/"thirdparty/magic/magic.py",
    ]
    inreplace files, "/usr/local", HOMEBREW_PREFIX

    bin.install_symlink libexec/"sqlmap.py"
    bin.install_symlink bin/"sqlmap.py" => "sqlmap"

    bin.install_symlink libexec/"sqlmapapi.py"
    bin.install_symlink bin/"sqlmapapi.py" => "sqlmapapi"
  end

  test do
    data = %w[Bob 14 Sue 12 Tim 13]
    create = "create table students (name text, age integer);\n"
    data.each_slice(2) do |n, a|
      create << "insert into students (name, age) values ('#{n}', '#{a}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)
    select = "select name, age from students order by age asc;"
    args = %W[--batch -d sqlite://school.sqlite --sql-query "#{select}"]
    output = shell_output("#{bin}/sqlmap #{args.join(" ")}")
    data.each_slice(2) { |n, a| assert_match "#{n}, #{a}", output }
  end
end
