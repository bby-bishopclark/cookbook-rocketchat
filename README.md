# RocketChat Cookbook

CookBook in Chef where I'll can install and use RocketChat which is chat software.

### Platforms

- AmazonLinux

### Chef

- Chef 12.0 or later

### Cookbooks

None.

## Attributes

### RocketChat::default

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['RocketChat']['ip']</tt></td>
    <td>Text</td>
    <td>Host of RocketChat</td>
    <td><tt>192.168.0.0</tt></td>
  </tr>
</table>

## Usage

### RocketChat::default

Just include `RocketChat` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[RocketChat]"
  ]
}
```

## License and Authors

Authors: nekonoprotocol

