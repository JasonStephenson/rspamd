context("Quoted-Printable encoding", function()
  local rspamd_util = require "rspamd_util"
  -- These test cases are derived from https://github.com/mathiasbynens/quoted-printable
  local cases = {
    {
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=',
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=3D',
      'Exactly 73 chars of which the last one is `=`'
    },
    {
      'If you believe that truth=beauty, then surely mathematics is the most beautiful branch of philosophy.',
      'If you believe that truth=3Dbeauty, then surely mathematics is the most bea=\r\nutiful branch of philosophy.',
      'Equals sign'
    },
    {
      'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum. Mirum est notare quam littera gothica, quam nunc putamus parum claram, anteposuerit litterarum formas humanitatis per seacula quarta decima et quinta decima. Eodem modo typi, qui nunc nobis videntur parum clari, fiant sollemnes in futurum.',
      'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy =\r\nnibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wi=\r\nsi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lo=\r\nbortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure d=\r\nolor in hendrerit in vulputate velit esse molestie consequat, vel illum dol=\r\nore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio digni=\r\nssim qui blandit praesent luptatum zzril delenit augue duis dolore te feuga=\r\nit nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue=\r\n nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non=\r\n habent claritatem insitam; est usus legentis in iis qui facit eorum clarit=\r\natem. Investigationes demonstraverunt lectores legere me lius quod ii legun=\r\nt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem =\r\nconsuetudium lectorum. Mirum est notare quam littera gothica, quam nunc put=\r\namus parum claram, anteposuerit litterarum formas humanitatis per seacula q=\r\nuarta decima et quinta decima. Eodem modo typi, qui nunc nobis videntur par=\r\num clari, fiant sollemnes in futurum.',
      '76-char line limit',
    },
    {
      'foo ',
      'foo=20',
      'Trailing space'
    },
    {
      'foo\t',
      'foo=09',
      'Trailing tab'
    },

    {
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=',
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=\r\n=3D',
      'Exactly 74 chars of which the last one is `=`'
    },
    {
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=',
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=\r\n=3D',
      'Exactly 75 chars of which the last one is `=`'
    },
    {
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=',
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=\r\n=3D',
      'Exactly 76 chars of which the last one is `=`',
    },
    {
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=',
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=\r\nx=3D',
      'Exactly 77 chars of which the last one is `=`'
    },
    {
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ',
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=20',
      'Exactly 73 chars of which the last one is a space'
    },
    {
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ',
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=20',
      'Exactly 74 chars of which the last one is a space'
    },
    {
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ',
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx =\r\n',
      'Exactly 75 chars of which the last one is a space'
    },
    {
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ',
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=\r\n=20',
      'Exactly 76 chars of which the last one is a space'
    },
    {
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ',
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=\r\nx=20',
      'Exactly 77 chars of which the last one is a space'
    },
  }
  for _,c in ipairs(cases) do
    test("QP encoding test case: " .. c[3], function()
      local res = {
        expect = c[2],
        actual = tostring(rspamd_util.encode_qp(c[1], 76))
      }
      assert_rspamd_eq(res)
    end)
  end
end)
